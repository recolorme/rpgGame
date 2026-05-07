class_name global extends Node

const GAME_SIZE: Vector2 = Vector2(320, 180)

var current_tilemap_bounds: Array[Vector2]
var persistPlayer = null
var currentScene = null

signal TileMapBoundsChanged(bounds: Array[Vector2])

@onready var playerScene = load("res://Overworld/player.tscn")

func _ready() -> void:
	var root = get_tree().get_root()
	currentScene = root.get_child(root.get_child_count() - 1)

	# if player doesnt exist, then its created and added to the scene
	if persistPlayer == null:
		var player = playerScene.instantiate()
		player.name = "Player"
		if currentScene.has_node("Objects"):
			var objects = currentScene.get_node("Objects")
			if objects != null:
				objects.add_child(player)
		else:
			currentScene.add_child(player)

		persistPlayer = player
		#player.position.x = 0
		#player.position.y = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		

## auto camera bounds handling for each map
func change_tilemap_bounds(bounds: Array[Vector2]) -> void:
	current_tilemap_bounds = bounds
	TileMapBoundsChanged.emit(bounds)

func test() -> void:
	print("test")
