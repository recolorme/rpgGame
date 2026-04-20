extends Marker2D

@export var enemy_scene: PackedScene

func _ready() -> void:
	var enemy = enemy_scene.instantiate()
	# position the enemy randomly within a 100x100 area centered on the spawner
	enemy.position = Vector2(randf_range(position.x-50, position.x+50), randf_range(position.y-50, position.y+50))
	add_child(enemy)
	pass

func _process(_delta: float) -> void:
	pass
