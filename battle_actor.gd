class_name BattleActor extends Resource

signal hp_changed(hp, change)

var name: String = "Not Set"
var hp_max: int = 1
var hp: int = hp_max
var mp_max: int = 0
var mp: int = mp_max
var strength: int = 1

func _init(_hp: int = hp_max, _strength: int = strength) -> void:
	hp_max = _hp
	hp = _hp
	strength = _strength

func set_name_custom(value: String) -> void:
	name = value

func healhurt(value: int) -> void:
	var hp_start: int = hp
	var change: int = 0
	hp += value
	hp = clampi(hp, 0, hp_max)
	change = hp - hp_start
	emit_signal("hp_changed", hp, change)
