extends Node

var enemies: Dictionary = {
	"RockSus": BattleActor.new(10,2,0), 
	"igor": BattleActor.new(20,6,0), # TODO: inputing data doesnt reflect actual battles????????????
	"igorBIG": BattleActor.new(20,6,0)
}

var bosses: Dictionary = {
	"igorTheDestroyer": BattleActor.new(150,14,6)
}

var players: Dictionary = {
	"PENGU":BattleActor.new(48,4,0),
	"PENPO":BattleActor.new(32,5,0),
	"PENNY":BattleActor.new(20,6,0),
	"PENIS":BattleActor.new(18,7,0),
}

var party: Array = players.values()

func _init() -> void:
	for player in party:
		player.friendly = true
	Util.set_keys_to_names(enemies)
	Util.set_keys_to_names(players)
	
