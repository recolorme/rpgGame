class_name BattleActorButton extends TextureButton

const HIT_TEXT: PackedScene = preload("res://hit_text.tscn")

const RECOIL: int = 8

var data: BattleActor = null
var tween: Tween = null

@onready var start_pos: Vector2 = position
@onready var recoil_direction: int = 1 if global_position.x > Globals.GAME_SIZE.x * 0.5 else -1

func set_data(_data: BattleActor) -> void:
	data = _data
	
	if data.texture:
		texture_normal = data.texture
	
	data.hp_changed.connect(_on_data_hp_changed)
	data.defeated.connect(_on_data_defeated)
	data.acting.connect(_on_data_acting)

func recoil() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	# start
	tween.tween_property(self, "position:x", start_pos.x + (RECOIL * recoil_direction), 0.25).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "self_modulate", Color.DARK_RED, 0.25).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	# end
	tween.tween_property(self, "position:x", start_pos.x, 0.1).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "self_modulate", Color.WHITE, 0.1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
func action_slide() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position:x", start_pos.x + (RECOIL * recoil_direction * -1), 0.25).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position:x", start_pos.x, 0.1).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)


func _on_data_hp_changed(hp: int, change: int) -> void:
	var hit_text: Label = HIT_TEXT.instantiate()
	hit_text.text = str(abs(change))
	add_child(hit_text)
	hit_text.position = Vector2(size.x * 0.5,-4)
	
	if sign(change) == -1:
		recoil()
		
	
	#hit text tweening up
	var textTween = create_tween()
	textTween.tween_property(hit_text, "position:y", hit_text.position.y - 20, 0.5)
	textTween.tween_property(hit_text, "modulate:a", 0.0, 0.5)
	textTween.finished.connect(func(): hit_text.queue_free())
	
	#player + enemy hurt tween
	recoil()
	
	
func _on_data_defeated() -> void:
	pass


func _on_data_acting() -> void:
	action_slide()
