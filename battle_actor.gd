class_name BattleActor extends Resource

signal hp_changed(hp, change)

var name: String = "Not Set"
var hp_max: int = 1
var hp: int = hp_max

func healhurt(value: int) -> void:
	var hp_start: int = hp
	var change: int = 0
	hp += value
	hp = clampi(hp, 0, hp_max)
	change = hp - hp_start
	emit_signal("hp_changed", hp, change)
	
