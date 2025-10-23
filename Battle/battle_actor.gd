class_name BattleActor extends Resource

signal hp_changed(hp, change)
signal defense_changed(defense, change)
signal defeated()
signal acting()

var name: String = "Not Set"
var hp_max: int = 1
var hp: int = hp_max
var mp_max: int = 0
var mp: int = mp_max
var strength: int = 4
var defense: int = 0
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
		texture = load("res://assets/enemies/" + name_formatted + ".png") #might need to duplicate
 
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

func act() -> void:
	acting.emit()

func defend(value: int) -> void:
	var defense_start: int = defense
	var change: int = 0
	defense += value
	change = defense + defense_start
	defense_changed.emit(defense, change)

func duplicate_custom() -> BattleActor:
	var dup: BattleActor = self.duplicate()
	#dup.init(hp,strength) #TODO might need this. need to test
	dup.name = name
	dup.texture = texture
	return dup
