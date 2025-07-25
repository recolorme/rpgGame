extends TextureRect

const OFFSET: Vector2 = Vector2(-18,0)

var target: Node = null

func _ready() -> void:
	get_viewport().gui_focus_changed.connect(_on_viewport_gui_focus_changed)
	set_process(false)
	hide()

func _process(_delta: float) -> void:
	global_position = target.global_position + OFFSET

func _on_viewport_gui_focus_changed(node: Control) -> void:
	
	if node is BaseButton:
		print("FOCUSED:", node.name)
		target = node
		show()
		set_process(true)
	else:
		hide()
		set_process(false)
