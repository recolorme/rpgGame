extends Control

@onready var _options: WindowDefault = $Options
@onready var _options_menu: Menu = $Options/Options

func _ready() -> void:
	#_options_menu.connectToButtons(self)
	_options_menu.buttonFocus(0)

func _onOptionsButtonFocused(button: BaseButton) -> void:
	pass

func _onOptionsButtonPressed(button: BaseButton) -> void:
	print(button.text)
