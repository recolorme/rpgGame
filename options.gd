class_name Menu extends Container

signal buttonFocused(button)
signal buttonPressed(button)

func getButtons() -> Array:
	return get_children()

func connectToButtons() -> void:
	for button in getButtons():
		button.pressed.connect(buttonPressed) #i was on 5:31 on the video
		#TODO: put project on github
