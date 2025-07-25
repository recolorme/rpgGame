extends Control

enum States {
	OPTIONS,
	TARGETS,
}

var state: States = States.OPTIONS
var atb_queue: Array = []
var event_queue: Array = []

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
	if atb_queue.is_empty():
		return
		
	var current_player: BattlePlayerBar = atb_queue.pop_front()
	current_player.reset()
	
	var next_player: BattlePlayerBar = atb_queue.front()
	if next_player:
		next_player.highlight()
		_options_menu.button_focus(0)
	else:
		get_viewport().gui_release_focus()
		_options.hide()
		_cursor.hide()
		
	
func _on_options_button_focused(button: BaseButton) -> void:
	pass

func _on_options_button_pressed(button: BaseButton) -> void:
	match button.text:
		"FIGHT":
			state = States.TARGETS
			_enemies_menu.button_focus()

func _on_player_atb_ready(player: BattlePlayerBar) -> void:
	if atb_queue.is_empty():
		player.highlight()
		_options.show()
		_options_menu.button_focus(0)
		
	atb_queue.append(player)

func _on_enemies_button_pressed(button: BaseButton) -> void:
		#TODO Store event here.
	state = States.OPTIONS
	advance_atb_queue()

func _on_players_button_pressed(button: BaseButton) -> void:
		#TODO Store event here.
	advance_atb_queue()
