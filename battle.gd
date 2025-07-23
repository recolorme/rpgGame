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

func _ready() -> void:
	_options.hide()
	_options_menu.buttonPressed.connect(_onOptionsButtonPressed)
	
	for player in _players_infos:
		player.atb_ready.connect(_on_player_atb_ready.bind(player))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		match state:
			States.OPTIONS:
				pass
			States.TARGETS:
				state = States.OPTIONS
				_options_menu.buttonFocus()

func advance_atb_queue() -> void:
	var current_player: BattlePlayerBar = atb_queue.pop_front()
	current_player.reset()
	atb_queue.front().highlight()

func _onOptionsButtonFocused(button: BaseButton) -> void:
	pass

func _onOptionsButtonPressed(button: BaseButton) -> void:
	match button.text:
		"FIGHT":
			state = States.TARGETS
			_enemies_menu.buttonFocus()

func _on_player_atb_ready(player: BattlePlayerBar) -> void:
	if atb_queue.is_empty():
		player.highlight(true)
		_options.show()
		_options_menu.button_focus(0)
		
	atb_queue.append(player)

func _on_enemies_button_pressed(button: BaseButton) -> void:
		#TODO Store event here.
	#advance_ath_queue()
	pass

func _on_players_button_pressed(button: BaseButton) -> void:
		#TODO Store event here.
	#advance_ath_queue()
	pass
