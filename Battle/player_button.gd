class_name PlayerButton extends BattleActorButton

func _ready() -> void:
	set_data(Data.party[get_index()])
	
	
func _on_data_defeated() -> void:
	self_modulate = Color.BLACK #TODO replace temporary solution here
