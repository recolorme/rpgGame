class_name BattleActor extends Resource

signal atb_ready()

signal hp_changed(hp, damage, defense)
#signal defense_changed(defense, damage)
signal defeated()
signal acting()
signal defending(hp, defense)

var name: String = "Not Set"
var hp_max: int = 1
var hp: int = hp_max
var mp_max: int = 0
var mp: int = mp_max
var strength: int = 4 # enemies taking this value?
var defense: int = 2 # doesnt seem to work
var texture: Texture = null
var friendly: bool = false

func _init(_hp: int = hp_max, _strength: int = strength, _defense: int = defense) -> void:
	hp_max = _hp
	hp = _hp
	strength = _strength
	defense = _defense

func set_name_custom(value: String) -> void:
	name = value
	
	if !friendly:
		var name_formatted: String = name.to_lower().replace(" ", "_")
		texture = load("res://assets/enemies/" + name_formatted + ".png") #might need to duplicate

## inflicts damage onto others 
func healhurt(actor_strength: int, target_defense: int) -> void:
	var hp_start: int = hp
	var damage: int = 0

	hp += actor_strength 
	hp += target_defense
	
	hp = clampi(hp, 0, hp_max)
	damage = hp - hp_start

	hp_changed.emit(hp, damage, target_defense)
	
	if !has_hp():
		defeated.emit()

func has_hp() -> bool:
	return hp > 0

func can_act() -> bool:
	return has_hp()

func act() -> void:
	acting.emit()


## defense equation for temporary boost 
func defend(value: int) -> void:
	var defense_start: int = defense

	defense += value
	defending.emit(hp, defense)

	# await atb_ready

	# defense = defense_start
	# defending.emit(null, null, defense)


func duplicate_custom() -> BattleActor:
	var dup: BattleActor = self.duplicate()
	dup._init(hp,strength,defense) 
	dup.name = name
	dup.texture = texture
	return dup
