class_name PlayerCamera extends Camera2D

@onready var parent = get_parent()

func _ready() -> void:
	Globals.TileMapBoundsChanged.connect(_on_bounds_changed)
	
	set_bounds_from_texture()

func set_bounds_from_texture() -> void:
	var scene_root = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
	# the "*" just finds any node for the sprite2d
	var map_sprite = scene_root.find_child("*", false, false)

	#print("scene root: ", scene_root.name)
	#print("map sprite found: ", map_sprite)

	if map_sprite is Sprite2D and map_sprite.texture:
		var texture_size = map_sprite.get_rect().size
		var sprite_pos = map_sprite.global_position - (texture_size / 2) * map_sprite.scale
		var bounds: Array[Vector2] = [
			sprite_pos,
			sprite_pos + texture_size * map_sprite.scale
		]
		#print("bounds set to: ", bounds)
		update_limits(bounds)

## updates camera limits based on bounds of current map
func update_limits(bounds: Array[Vector2]) -> void:
	limit_left = int(bounds[0].x)
	limit_top = int(bounds[0].y)
	limit_right = int(bounds[1].x)
	limit_bottom = int(bounds[1].y)

func _on_bounds_changed(bounds: Array[Vector2]) -> void:
	update_limits(bounds)
