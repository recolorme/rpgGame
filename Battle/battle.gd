extends Control

enum States {
	OPTIONS,
	TARGETS,
	VICTORY,
	GAMEOVER,
}

enum Actions{
	FIGHT,
	SKILL,
	ITEM,
	DEFEND
}

enum {
	ACTOR,
	TARGET,
	ACTION,
}

var state: States = States.OPTIONS
var player_atb_queue: Array = []
var event_queue: Array = []
var event_running: bool = false
var action: Actions = Actions.FIGHT
var player: BattleActor = null

@onready var _gui: Control = $GUIMargin
@onready var _options: WindowDefault = $Options
@onready var _options_menu: Menu = $Options/Options
@onready var _enemies_menu: Menu = $Enemies
@onready var _players_menu: Menu = $Players
@onready var _players_infos: Array = $GUIMargin/Bottom/Players/MarginContainer/PlayerInfos.get_children()
@onready var _cursor: MenuCursor = $MenuCursor
@onready var _down_cursor: TextureRect = $DownCursor

func _ready() -> void:
	_options.hide()
	_down_cursor.hide()
	
	# Connect players and enemies
	var data: BattleActor = null
	for player_info in _players_infos:
		data = player_info.data
		player_info.atb_ready.connect(_on_player_atb_ready.bind(player_info))
		player_info.data.defeated.connect(_on_battle_actor_defeated.bind(data))
		
	for enemy_button in _enemies_menu.get_buttons():
		data = enemy_button.data
		enemy_button.atb_ready.connect(_on_enemy_atb_ready.bind(data))
		data.defeated.connect(_on_battle_actor_defeated.bind(data))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		match state:
			States.OPTIONS:
				pass
			States.TARGETS:
				state = States.OPTIONS
				_options_menu.button_focus()

func find_valid_target(target: BattleActor) -> BattleActor:
	if target.has_hp():
		return target
	
	var target_buttons: Array = []
	var target_is_friendly: bool = target.friendly
	if target_is_friendly:
		target_buttons = _players_menu.get_buttons()
	else:
		target_buttons = _enemies_menu.get_buttons()
		
	target = null
	target_buttons.shuffle()
	for i in range(target_buttons.size()):
		var button: BattleActorButton = target_buttons[i]
		var data: BattleActor = button.data
		if data.has_hp():
			target = data
			break
	
	if target == null:
		state = States.GAMEOVER if target_is_friendly else States.VICTORY
	return target

func end() -> void:
	event_queue.clear()
	player_atb_queue.clear()
	_cursor.hide()
	_options.hide()
	_down_cursor.hide()
	await get_tree().create_timer(1.0).timeout
	_gui.hide()

	for player_info in _players_infos:
		player_info.highlight(false)
		player_info.reset()
		player_info.stop()
		
	# TODO actual battle end states
	match state:
		States.VICTORY:
			print("wiener is you")
		States.GAMEOVER:
			print("loser loser loser")

func advance_atb_queue(remove_front: bool = true) -> void: 
	if state >= States.VICTORY:
		return
	state = States.OPTIONS
	
	if player_atb_queue.is_empty():
		return
		
	if remove_front:
		var current_player_info_bar: PlayerInfoBar = player_atb_queue.pop_front()
		current_player_info_bar.highlight(false)
	
	if player_atb_queue.is_empty():
		get_viewport().gui_release_focus()
		_options.hide()
		_cursor.hide()
		_down_cursor.hide()
	else:
		var next_player_info_bar: PlayerInfoBar = player_atb_queue.front()
		var index: int = next_player_info_bar.get_index()
		next_player_info_bar.highlight()
		player = Data.party[index]
		_options.show()
		_options_menu.button_focus(0)
		_down_cursor.show()
		_down_cursor.global_position = _players_menu.get_buttons()[index].global_position + Vector2(24,-20)

func wait(duration: float):
	await get_tree().create_timer(duration).timeout

func run_event() -> void:
	if event_queue.is_empty():
		event_running = false
		return
	
	event_running = true
	await get_tree().create_timer(0.5).timeout
	
	if state >= States.VICTORY:
		return
	
	var event: Array = event_queue.pop_front()
	var actor: BattleActor = event[ACTOR]
	var target: BattleActor = event[TARGET]
	
	# skip event if actor can no longer act
	if !actor.can_act():
		run_event()
	
	# ensure target is valid
	target = find_valid_target(target)
		
	# no valid target. one side has wwon
	if target == null:
		end()
		return
			
	# perform action
	actor.act()
	await get_tree().create_timer(0.25).timeout
	match event[ACTION]:
		Actions.FIGHT:
			target.healhurt(-actor.strength)
		Actions.DEFEND:
			actor.defend(actor.defense)
		_:
			pass
	
	#await wait(0.75)
	await get_tree().create_timer(1.25).timeout
	
	if actor.friendly:
		_players_infos[Data.party.find(actor)].reset()
	else:
		var enemies: Array = _enemies_menu.get_children()
		for enemy in enemies:
			if enemy.data == actor:
				enemy.reset()
				break
				
	run_event()


## adds an event to the ATB queue (self, target, action)
func add_event(event: Array) -> void: 

	event_queue.append(event)
	if !event_running:
		run_event()

func _on_options_button_pressed(button: BaseButton) -> void:
	match button.text:
		"FIGHT":
			action = Actions.FIGHT
			state = States.TARGETS
			_enemies_menu.button_focus()
		"SKILL":
			pass
		"ITEM":
			pass
		"DEFEND":
			# you can copy this code block to other action buttons
			action = Actions.DEFEND
			add_event([player, player, action])
			advance_atb_queue()
			#state = States.OPTIONS
			#_options_menu.button_focus()
			

func _on_player_atb_ready(player_info: PlayerInfoBar) -> void:
	player_atb_queue.append(player_info)
	if player_atb_queue.size() == 1:
		advance_atb_queue(false)
	
func _on_enemy_atb_ready(enemy: BattleActor) -> void:
	var target: BattleActor = Data.party.pick_random()
	add_event([enemy, target, Actions.FIGHT]) #TODO choosing action

func _on_enemies_button_pressed(button: EnemyButton) -> void:
	var target: BattleActor = button.data
	add_event([player, target, action])
	advance_atb_queue()

func _on_players_button_pressed(button: PlayerButton) -> void:
	var target: BattleActor = button.data
	add_event([player, target, action])
	advance_atb_queue()

func _on_battle_actor_defeated(data: BattleActor) -> void:
	if !find_valid_target(data):
		end()
		
	var player_index: int = Data.party.find(data)
	if player_index != -1:
		var player_info: PlayerInfoBar = _players_infos[player_index]
		player_atb_queue.erase(player_info)
