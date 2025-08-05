class_name PlayerButton extends BattleActorButton

func _ready() -> void:
	set_data(Data.party[get_index()])
	
