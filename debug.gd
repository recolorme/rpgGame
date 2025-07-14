extends Node

func _unhandled_input(event: InputEvent) -> void:
	var tutorialGuyIsGettingMad: InputEventKey = event
	if event.is_pressed():
		var key: int = tutorialGuyIsGettingMad.keycode
		match key:
			KEY_R:
				get_tree().reload_current_scene()
			KEY_Q:
				get_tree().quit()
			KEY_F11:
				var isFullscreen: bool = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
				var targetMode: int = DisplayServer.WINDOW_MODE_WINDOWED if isFullscreen else DisplayServer.WINDOW_MODE_FULLSCREEN
				DisplayServer.window_set_mode(targetMode)
