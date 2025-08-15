extends Node

var enemies: Dictionary = {
	"RockSus": BattleActor.new(),
	"Igor": BattleActor.new(),
}

var players: Dictionary = {
	"RECO":BattleActor.new(48,4),
	"WALU":BattleActor.new(32,2),
	"<:3c":BattleActor.new(20),
	"POOP":BattleActor.new(18),
}

var party: Array = players.values()

func _init() -> void:
	for player in party:
		player.friendly = true
	Util.set_keys_to_names(enemies)
	Util.set_keys_to_names(players)
	
