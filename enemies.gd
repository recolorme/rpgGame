extends Node

var data: Dictionary = {
	"RockSus": BattleActor.new()
}

func _init() -> void:
	Util.set_keys_to_names(data)
