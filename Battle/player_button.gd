class_name PlayerButton extends BattleActorButton

func _ready() -> void:
	set_data(Data.party[get_index()])
	
func _on_data_defeated() -> void:
	#self_modulate = Color.BLACK #TODO replace temporary solution here
	
	# they indefinitely stay red
	tween.parallel().tween_property(self, "modulate", Color.DARK_RED, 0.25).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	await get_tree().create_timer(1.0).timeout
	self.rotation_degrees = 270
