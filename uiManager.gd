extends Node

@onready var textbox_res: PackedScene = preload("res://Text/textbox.tscn")

var textbox: textboxHandler
var ui_active: bool = false
var ui_layer = null
var ui_stack = []

func _ready():
    var ui_layer_node = load("res://uiLayer.tscn")

    if ui_layer == null:
        ui_layer = ui_layer_node.instantiate()
        Global.current_scene.add_child(ui_layer)


func _process(_delta):
    pass

func open_textbox():
    textbox = textbox_res.instantiate()
    add_ui(textbox)
    #textbox.show_textbox()

    # Show on next frame so the node is in the tree and onready paths resolve.
    textbox.call_deferred("show_textbox")
    return textbox


func add_ui(ui, ui_add_child = true) -> void:
    ui_stack.push_front(ui)
    ui_active = true
    if ui_add_child:
        ui_layer.call_deferred("add_child", ui)

