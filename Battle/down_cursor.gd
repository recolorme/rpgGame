extends TextureRect

@onready var height: float = size.y
@onready var atlas_height: float = texture.atlas.get_size().y

func _on_frame_advance_timeout() -> void:
	texture.region.position.y += height
	texture.region.position.y = wrapf(texture.region.position.y, 0, atlas_height)
