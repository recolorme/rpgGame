class_name EnemyButton extends TextureButton

var data: BattleActor = Data.enemies.RockSus.duplicate()

@onready var _atb_bar: ATBBar = $ATBBar

func _read() -> void:
	# TODO load sprite
	# TODO connect to data signals
	pass
