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
	data.hp_changed.connect(_on_data_hp_changed)

func _on_data_hp_changed(hp: int, change: int) -> void:
	_health.text = str(hp)
	if hp == 0:
		modulate = Color.DARK_RED
		_atb.reset()
		_atb.stop()
		
func highlight(on: bool = true) -> void:
	var anim: String = "highlight" if on else "RESET"
	_anim.play(anim)

func reset() -> void:
	_atb.reset()

func _on_atb_bar_filled() -> void:
	atb_ready.emit()

func stop() -> void:
	_atb.stop()
