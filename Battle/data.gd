extends Node

var enemies: Dictionary = {
	"RockSus": BattleActor.new(10,2,0), 
	"igor": BattleActor.new(20,6,0),
	"igorBIG": BattleActor.new(20,10,0)
}

var bosses: Dictionary = {
	"igorTheDestroyer": BattleActor.new(150,14,6)
}

var players: Dictionary = {
	"PENGU":BattleActor.new(48,4,4),
	"PENPO":BattleActor.new(32,5,4),
	"PENNY":BattleActor.new(20,6,4),
	"PENIS":BattleActor.new(18,7,4),
}

var party: Array = players.values()

func _init() -> void:
	for player in party:
		player.friendly = true
	Util.set_keys_to_names(enemies)
	Util.set_keys_to_names(players)
	
