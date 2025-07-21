class_name Menu extends Control

signal buttonFocused(button: BaseButton)
signal buttonPressed(button: BaseButton)

@export var autoWrap: bool = true

var i: int = 0
var exiting: bool = false

#TODO: replace all blue text values with camelCase if possible
func _ready() -> void:
	tree_exiting.connect(_on_tree_exiting)
	
	#Connect to buttons
	for button in getButtons():
		button.focus_exited.connect(_on_Button_focus_exited.bind(button))
		button.focus_entered.connect(_onButtonFocused.bind(button))
		button.pressed.connect(_onButtonPressed.bind(button))
		
	#Set focus neighbors
	#TODO Fix for grids (pass only issue with > 2 column grid)
	# NOTE Negative separation values will cause issues with auto neighbor focus for middle controls
	if !autoWrap:
		return
		
	var _class: String = get_parent().get_class()
	var buttons: Array = getButtons()
	var useThisOnGridContainers: bool = false #hot fix
	
	if useThisOnGridContainers and get("columns"): #GridContainer
		var topRow: Array = []
		var bottomRow: Array = []
		var cols: int = self.columns
		var rows: int = round(buttons.size() / cols)
		var btmRange: Array = [rows * cols - cols, rows * cols - 1]
#		var btmRange: Array = [rows * (cols - 1) + 1, rows * cols]	
	
#		print(btm_range)
	
		#if clear_first:
			#for button in buttons:
				#button.focus_neighbor_top = null
				#button.focus_neighbor_bottom = null
				
		# Get top and bottom rows of buttons
		for x in cols:
#			print(buttons[x].text)
			topRow.append(buttons[x])
		for x in range(btmRange[0], btmRange[1] + 1):
#			print(x)
			if x > buttons.size():
#				print(buttons[x - cols].text)
				bottomRow.append(buttons[x - cols])
				continue
#			print(buttons[x].text)
			bottomRow.append(buttons[x])
			
		# Change their focus neighbors accordingly.
		for x in cols:
			var topButton: BaseButton = topRow[x]
			var bottomButton: BaseButton = bottomRow[x]
#			print(topButton)
#			print(bottomButton)
			if topButton == bottomButton:
				continue
			topButton.focus_neighbor_top = bottomButton.get_path()
			bottomButton.focus_neighbor_bottom = topButton.get_path()
			
		# Repeat for left and right columns.
		for i in range(0, buttons.size(), cols):
			var leftButton: BaseButton = buttons[i]
			var rightButton: BaseButton = buttons[i+ cols - 1]
#			print(leftButton, "...", rightButton)
			leftButton.focus_neighbor_left = rightButton.get_path()
			rightButton.focus_neighbor_right = leftButton.get_path()
	elif _class.begins_with("VBox"):
		for x in range(buttons.size()): #button wrapping code############### DIFFERS FROM TUT
			var button: BaseButton = buttons[x]
			var above = buttons[(x - 1 + buttons.size()) % buttons.size()]
			var below = buttons[(x + 1) % buttons.size()]
			
			button.focus_neighbor_top = above.get_path()
			button.focus_neighbor_bottom = below.get_path()
			button.focus_neighbor_left = NodePath("")
			button.focus_neighbor_right = NodePath("")################# DIFFERS FROM TUT
	elif _class.begins_with("HBox"):
		var firstButton: BaseButton = buttons.front()
		var lastButton: BaseButton = buttons.back()
		firstButton.focus_neighbor_left = lastButton.get_path()
		lastButton.focus_neighbor_right = firstButton.get_path()

	button_enable_focus(false)

func getButtons() -> Array:
	return get_children().filter(func(n): return n is BaseButton)

func connectToButtons(target: Object, _name: String = name) -> void:
	var callable: Callable = Callable()
	callable = Callable(target, "_on_" + _name + "_focused")
	buttonFocused.connect(callable)
	callable = Callable(target, "_on_" + _name + "_pressed")
	buttonPressed.connect(callable)

func button_enable_focus(on: bool) -> void:
	var mode: FocusMode = FocusMode.FOCUS_ALL if on else FocusMode.FOCUS_NONE
	for button in getButtons():
		button.set_focus_mode(mode)

func buttonFocus(n: int = i) -> void:
	button_enable_focus(true)
	var button: BaseButton = getButtons()[n]
	button.grab_focus()

func _on_Button_focus_exited(button: BaseButton) -> void:
	await get_tree().process_frame
	if exiting:
		return
		
	if not get_viewport().gui_get_focus_owner() in getButtons():
		button_enable_focus(false)

func _onButtonFocused(button: BaseButton) -> void:
	i = button.get_index()
	emit_signal("buttonFocused", button)

func _onButtonPressed(button: BaseButton) -> void:
	emit_signal("buttonPressed", button)

func _on_tree_exiting() -> void:
	exiting = true
