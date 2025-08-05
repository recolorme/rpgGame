class_name PlayerButton extends BattleActorButton

func _ready() -> void:
	data = Data.party[get_index()]
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
