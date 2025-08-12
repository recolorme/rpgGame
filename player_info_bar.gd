class_name PlayerInfoBar extends HBoxContainer

signal atb_ready()

@onready var data: BattleActor = Data.party[get_index()]
@onready var _name: Label = $Name
@onready var _health: Label = $Health
@onready var _mana: Label = $Mana
@onready var _atb: ATBBar = $ATBBar
@onready var _anim: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	_anim.play("RESET")
	_name.text = data.name
	_health.text = str(data.hp)
	_mana.text = str(data.mp)

func highlight(on: bool = true) -> void:
	var anim: String = "highlight" if on else "RESET"
	_anim.play(anim)

func reset() -> void:
	highlight(false)
	_atb.reset()

func _on_atb_bar_filled() -> void:
	atb_ready.emit()
