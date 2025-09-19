class_name EnemyButton extends BattleActorButton 

signal atb_ready()

@onready var _atb_bar: ATBBar = $ATBBar

func _ready() -> void:
	set_data(Data.enemies["igorBIG"].duplicate_custom())

func reset() -> void:
	_atb_bar.reset()

func _on_atb_bar_filled() -> void:
	atb_ready.emit()
	#_atb_bar.reset()

func _on_data_defeated() -> void:
	_atb_bar.stop()
	await get_tree().create_timer(1.0).timeout
	queue_free()
