extends Node

const PRINT_CURRENT_FOCUS: bool = false

func _ready() -> void:
	if PRINT_CURRENT_FOCUS:
		get_viewport().gui_focus_changed.connect(_on_viewport_gui_focus_changed)

func _unhandled_input(event: InputEvent) -> void:
	var tutorial_guy_is_getting_mad: InputEventKey = event
	if event.is_pressed():
		var key: int = tutorial_guy_is_getting_mad.keycode
		match key:
			KEY_R:
				get_tree().reload_current_scene()
			KEY_Q:
				get_tree().quit()
			KEY_F11:
				var isFullscreen: bool = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
				var targetMode: int = DisplayServer.WINDOW_MODE_WINDOWED if isFullscreen else DisplayServer.WINDOW_MODE_FULLSCREEN
				DisplayServer.window_set_mode(targetMode)

func _on_viewport_gui_focus_changed(_node: Control) -> void:
	#print(node)
	pass
