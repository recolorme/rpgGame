class_name PlayerButton extends BattleActorButton

func _ready() -> void:
	set_data(Data.party[get_index()])
	
func _on_data_hp_changed(hp: int, change: int) -> void:
	super(hp, change)
	
	if hp <= 0:
		self_modulate = Color.BLACK
		
