extends Node

var enemies: Dictionary = {
	"RockSus": BattleActor.new(10,2), 
	"igor": BattleActor.new(20,6), # TODO: inputing data doesnt reflect actual battles????????????
	"igorBIG": BattleActor.new(20,6)
}

var players: Dictionary = {
	"PENGU":BattleActor.new(48,4),
	"PENPO":BattleActor.new(32,2),
	"PENNY":BattleActor.new(20,1),
	"PENIS":BattleActor.new(18,1),
}

var party: Array = players.values()

func _init() -> void:
	for player in party:
		player.friendly = true
	Util.set_keys_to_names(enemies)
	Util.set_keys_to_names(players)
	
