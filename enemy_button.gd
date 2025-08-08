class_name EnemyButton extends BattleActorButton 

signal atb_ready()

@onready var _atb_bar: ATBBar = $ATBBar

func _ready() -> void:
	# TODO load data based on overworld tile/cohort
	set_data(Data.enemies.RockSus.duplicate())

func _on_atb_bar_filled() -> void:
	atb_ready.emit()
	_atb_bar.reset()

func _on_data_hp_changed(hp: int, change: int) -> void:
	super(hp, change)
	
	if hp <= 0:
		await get_tree().create_timer(1.0).timeout
		queue_free()
		


#TODO 19:33 in video
