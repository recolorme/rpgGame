extends Control

enum States {
	OPTIONS,
	TARGETS,
}

enum Actions{
	FIGHT,
}

var state: States = States.OPTIONS
var atb_queue: Array = []
var event_queue: Array = []
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
	
	for player in _players_infos:
		player.atb_ready.connect(_on_player_atb_ready.bind(player))

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
		next_player_info_bar.highlight()
		_options_menu.button_focus(0)

func _on_options_button_pressed(button: BaseButton) -> void:
	match button.text:
		"FIGHT":
			action = Actions.FIGHT
			state = States.TARGETS
			_enemies_menu.button_focus()

func _on_player_atb_ready(player: PlayerInfoBar) -> void:
	if atb_queue.is_empty():
		player.highlight()
		_options.show()
		_options_menu.button_focus(0)
		
	atb_queue.append(player)

func _on_enemies_button_pressed(button: EnemyButton) -> void:
	var target: BattleActor = button.data
	event_queue.append([player, target, action])
	advance_atb_queue()

func _on_players_button_pressed(button: PlayerButton) -> void:
	var target: BattleActor = button.data
	event_queue.append([player, target, action])
	advance_atb_queue()
