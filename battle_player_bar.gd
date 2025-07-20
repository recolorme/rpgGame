class_name BattlePlayerBar extends HBoxContainer

signal atb_ready()

@onready var _anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	_anim.play("RESET")

func highlight(on: bool) -> void:
	var anim: String = "highlight" if on else "RESET"
	_anim.play(anim)

func _on_atb_bar_filled() -> void:
	atb_ready.emit()
