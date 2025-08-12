extends Control

enum States {
	OPTIONS,
	TARGETS,
}

enum Actions{
	FIGHT,
}

enum {
	ACTOR,
	TARGET,
	ACTION,
}

var state: States = States.OPTIONS
var atb_queue: Array = []
var event_queue: Array = []
var event_running: bool = false
var action: Actions = Actions.FIGHT
var player: BattleActor = null

@onready var _options: WindowDefault = $Options
@onready var _options_menu: Menu = $Options/Options
@onready var _enemies_menu: Menu = $Enemies
@onready var _players_menu: Menu = $Players
@onready var _players_infos: Array = $GUIMargin/Bottom/Players/MarginContainer/VBoxContainer.get_children()
@onready var _cursor: MenuCursor = $MenuCursor

func _ready() -> void:
	_options.hide()
	
	for player_info in _players_infos:
		player_info.atb_ready.connect(_on_player_atb_ready.bind(player_info))
		
	for enemy_button in _enemies_menu.get_buttons():
		enemy_button.atb_ready.connect(_on_enemy_atb_ready.bind(enemy_button.data))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		match state:
			States.OPTIONS:
				pass
			States.TARGETS:
				state = States.OPTIONS
				_options_menu.button_focus()

func advance_atb_queue() -> void:
	state = States.OPTIONS
	
	if atb_queue.is_empty():
		return
		
	var current_player_info_bar: PlayerInfoBar = atb_queue.pop_front()
	current_player_info_bar.reset()
	
	if atb_queue.is_empty():
		get_viewport().gui_release_focus()
		_options.hide()
		_cursor.hide()
	else:
		var next_player_info_bar: PlayerInfoBar = atb_queue.front()
		player = Data.party[next_player_info_bar.get_index()]
		#print("yes")
		_options_menu.button_focus(0)

func wait(duration: float):
	await get_tree().create_timer(duration).timeout

func run_event() -> void:
	if event_queue.is_empty():
		event_running = false
		return
	
	event_running = true
	await get_tree().create_timer(0.5).timeout
	
	var event: Array = event_queue.pop_front() 
	var actor: BattleActor = event[ACTOR]
	var target: BattleActor = event[TARGET]
	
	# TODO hp/valid actor/target checks
	
	match event[ACTION]:
		Actions.FIGHT:
			target.healhurt(-actor.strength)
		_:
			pass
	
	#await wait(0.75)
	await get_tree().create_timer(1.25).timeout
	run_event()

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

func _on_player_atb_ready(player_info: PlayerInfoBar) -> void:
	if atb_queue.is_empty():
		player = Data.party[player_info.get_index()]
		player_info.highlight()
		_options.show()
		_options_menu.button_focus(0)
		
	atb_queue.append(player_info)
	
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
