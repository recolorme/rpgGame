extends Node

const GAME_SIZE: Vector2 = Vector2(320, 180)

var current_tilemap_bounds: Array[Vector2]
signal TileMapBoundsChanged(bounds: Array[Vector2])

func _ready() -> void:
	randomize()

## auto camera bounds handling for each map
func change_tilemap_bounds(bounds: Array[Vector2]) -> void:
	current_tilemap_bounds = bounds
	TileMapBoundsChanged.emit(bounds)
