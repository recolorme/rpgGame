extends Node

var enemies: Dictionary = {
	"RockSus": BattleActor.new()
}

var players: Dictionary = {
	"RECO":BattleActor.new(),
	"WALU":BattleActor.new(),
	"<:3c":BattleActor.new(),
	"POOP":BattleActor.new()
}

var party: Array = players.values()

func _init() -> void:
	Util.set_keys_to_names(enemies)
	Util.set_keys_to_names(players)
	
