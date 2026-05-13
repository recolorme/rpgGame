class_name npc extends CharacterBody2D

@export var json_path: String = ""
@export var no_collision: bool

# @onready var textbox_handler = get_node("../Textbox") as textboxHandler
@onready var interactable: Area2D = $interactable
@onready var collision: CollisionShape2D = $CollisionShape2D

var text_array: Array[String]
var text: String = ""
var player_in_range = false

func _ready():
	_set_text()

	interactable.body_entered.connect(_on_body_entered)
	interactable.body_exited.connect(_on_body_exited)

	# no text is loaded from json
	text = json_path
	if text == "":
		$interactable/CollisionShape2D.disabled = true
	# disables collision from inspector
	if no_collision:
		collision.disabled = true


func _process(_delta) -> void:
	if player_in_range and Input.is_action_just_pressed("ui_accept"):
		run_interaction()

func _set_text():
	pass

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		player_in_range = true
		var interaction_hint: Sprite2D = body.get_node_or_null("interactionHint") as Sprite2D
		if interaction_hint != null:
			interaction_hint.visible = true

func _on_body_exited(body: Node) -> void:
	if body.name == "Player":
		player_in_range = false
		var interaction_hint: Sprite2D = body.get_node_or_null("interactionHint") as Sprite2D
		if interaction_hint != null:
			interaction_hint.visible = false

func run_interaction():
	# if textbox_handler == null:
	# 	printerr("TextboxHandler not found.")
	# 	return
	
	# var json_helper = get_node_or_null("../../Textbox/TextboxUI/JSONHelper") as Node
	# if json_helper == null:
	# 	printerr("JSONHelper not found.")
	# 	return
	
	# text_array = json_helper.call("load_dialogue", json_path)


	#text = "mmg"
	Global.set_text("test", self)
	# Global.set_text(json_path, self) 
	uiManager.open_textbox()
	# textbox.text_queue = text_array
	Global.persist_player.pause()


	# Only add new lines if the textbox is idle
	# if textbox_handler.current_state == textbox_handler.State.IDLE:
	# 	textbox_handler.text_queue = text_array
	
func stop_interaction():
	pass
