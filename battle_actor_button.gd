class_name BattleActorButton extends TextureButton

const HIT_TEXT: PackedScene = preload("res://hit_text.tscn")

var data: BattleActor = null

func set_data(_data: BattleActor) -> void:
	data = _data
	# TODO load sprite
	data.hp_changed.connect(_on_data_hp_changed)
	data.defeated.connect(_on_data_defeated)
	
func _on_data_hp_changed(hp: int, change: int) -> void:
	var hit_text: Label = HIT_TEXT.instantiate()
	hit_text.text = str(abs(change))
	add_child(hit_text)
	hit_text.position = Vector2(size.x * 0.5,-4)
	
	var tween = create_tween()
	tween.tween_property(hit_text, "position:y", hit_text.position.y - 20, 0.5)
	tween.tween_property(hit_text, "modulate:a", 0.0, 0.5)
	tween.finished.connect(func(): hit_text.queue_free())
	
func _on_data_defeated() -> void:
	pass
