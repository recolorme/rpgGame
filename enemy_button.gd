class_name EnemyButton extends BattleActorButton

signal atb_ready()

@onready var _atb_bar: ATBBar = $ATBBar

func _ready() -> void:
	# TODO load data based on overworld tile/cohort 
	# TODO load sprite
	data = Data.enemies.RockSus.duplicate()
	data.hp_changed.connect(_on_data_hp_changed)

func _on_data_hp_changed(hp: int, change: int) -> void:
	var hit_text: Label = HIT_TEXT.instantiate()
	hit_text.text = str(abs(change))
	add_child(hit_text)
	hit_text.position = Vector2(size.x + 0.5,-4)
	
	if hp <= 0:
		await get_tree().create_timer(1.0).timeout
		queue_free()

func _on_atb_bar_filled() -> void:
	atb_ready.emit()
