class_name EnemyButton extends TextureButton

signal atb_ready()

const HIT_TEXT: PackedScene = preload("res://hit_text.tscn")

var data: BattleActor = Data.enemies.RockSus.duplicate()

@onready var _atb_bar: ATBBar = $ATBBar

func _read() -> void:
	# TODO load sprite
	data.hp_changed.connect(_on_data_hp_changed)

func _on_data_hp_changed(hp: int, change: int) -> void:
	var hit_text: Label = HIT_TEXT.instantiate()
	hit_text.text = str(abs(change))
	add_child(hit_text)
	hit_text.position = Vector2(size.x + 0.5,-4)
	
	if hp <= 0:
		await get_tree().create_timer(1.0).timeout
		queue_free()

func _on_atb_bar_filled() -> void:
	atb_ready.emit()
