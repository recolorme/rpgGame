extends Marker2D

@export var enemy_scene: PackedScene
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite.hide()
	var enemy = enemy_scene.instantiate()
	
	# position the enemy randomly within a 50x50 area centered on the spawner
	enemy.position = Vector2(randf_range(position.x-25, position.x+25), randf_range(position.y-25, position.y+25))
	add_child(enemy)
	pass

func _process(_delta: float) -> void:
	pass
