class_name BattleActor extends Resource

signal hp_changed(hp, change)
signal defeated()

var name: String = "Not Set"
var hp_max: int = 1
var hp: int = hp_max
var mp_max: int = 0
var mp: int = mp_max
var strength: int = 1
var texture: Texture = null
var friendly: bool = false

func _init(_hp: int = hp_max, _strength: int = strength) -> void:
	hp_max = _hp
	hp = _hp
	strength = _strength

func set_name_custom(value: String) -> void:
	name = value
	
	if !friendly:
		var name_formatted: String = name.to_lower().replace(" ", "_")
		texture = load("res://assets/enemies" + name_formatted + ".png")

func healhurt(value: int) -> void:
	var hp_start: int = hp
	var change: int = 0
	hp += value
	hp = clampi(hp, 0, hp_max)
	change = hp - hp_start
	hp_changed.emit(hp, change)
	
	if !has_hp():
		defeated.emit()

func has_hp() -> bool:
	return hp > 0

func can_act() -> bool:
	return has_hp()
