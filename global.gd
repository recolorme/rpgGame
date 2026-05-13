extends Node

const GAME_SIZE: Vector2 = Vector2(320, 180)

var current_tilemap_bounds: Array[Vector2]
var persist_player = null
var current_scene = null 
var ui_layer = null
var text = []
var receiver = null
var parent_node: Node = current_scene

signal TileMapBoundsChanged(bounds: Array[Vector2])

@onready var player_scene = load("res://Overworld/player.tscn")

func _ready() -> void:
	var root = get_tree().get_root()
	
	current_scene = root.get_child(root.get_child_count() - 1)
	parent_node = current_scene
	if current_scene == null:
		return



	# ensures that multiple players dont spawn
	var existing_player = get_tree().get_root().find_child("Player", true, false)
	if existing_player:
		persist_player = existing_player

		if current_scene.has_node("Objects"):
			parent_node = current_scene.get_node("Objects")
		if existing_player.get_parent() != parent_node:
			existing_player.reparent(parent_node)

		existing_player.position = Vector2.ZERO
		return

	
	# spawn player into the currently active scene (prefer an "Objects" node).
	var player: Node = player_scene.instantiate()
	player.name = "Player"

	
	parent_node.add_child(player)


	persist_player = player
	player.position.x = 0
	player.position.y = 0

	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

		

## auto camera bounds handling for each map
func change_tilemap_bounds(bounds: Array[Vector2]) -> void:
	current_tilemap_bounds = bounds
	TileMapBoundsChanged.emit(bounds)

func set_text(path: String, scene_npc = null) -> void:
	text.append(["res://Text/Dialogues/" + path + ".txt", scene_npc])

	# dialogue.append(["res://Data/Dialogue/" + path +".yaml", npc])

# Call this function with the path to your JSON file
func load_dialogue(path: String) -> Array:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open file: %s" % path)
		return []

	var json_text = file.get_as_text()
	file.close()

	var json = JSON.new()
	json.parse(json_text)

	if typeof(json.data) != TYPE_ARRAY:
		push_error("JSON is not an array!")
		return []

	return json.data
