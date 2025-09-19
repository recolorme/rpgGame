extends Node

var enemies: Dictionary = {
	"RockSus": BattleActor.new(),
	"igor": BattleActor.new(),
	"igorBIG": BattleActor.new(),
}

var players: Dictionary = {
	"PENGU":BattleActor.new(48,4),
	"PENPO":BattleActor.new(32,2),
	"PENNY":BattleActor.new(20),
	"PENIS":BattleActor.new(18),
}

var party: Array = players.values()

func _init() -> void:
	for player in party:
		player.friendly = true
	Util.set_keys_to_names(enemies)
	Util.set_keys_to_names(players)
	
