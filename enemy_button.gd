class_name EnemyButton extends BattleActorButton 

signal atb_ready()

@onready var _atb_bar: ATBBar = $ATBBar

func _ready() -> void:
	# TODO load data based on overworld tile/cohort
	set_data(Data.enemies.RockSus.duplicate())

func _on_atb_bar_filled() -> void:
	atb_ready.emit()
