class_name BattleActorButton extends TextureButton

const HIT_TEXT: PackedScene = preload("res://Battle/hit_text.tscn")

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
	data.defending.connect(_on_data_defend)

func recoil() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	# start
	tween.tween_property(self, "position:x", start_pos.x + (RECOIL * recoil_direction), 0.25).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate", Color.DARK_RED, 0.25).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	# end
	tween.tween_property(self, "position:x", start_pos.x, 0.1).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate", Color.WHITE, 0.1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
func action_slide() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position:x", start_pos.x + (RECOIL * recoil_direction * -1), 0.25).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position:x", start_pos.x, 0.1).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)

## defense animation
func defend() -> void:
	if tween:
		tween.kill()
	tween = create_tween()

	# start
	tween.tween_property(self, "modulate", Color.CYAN, 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	# end 
	tween.tween_property(self, "modulate", Color.WHITE, 0.1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func text_tween_up(value) -> void:
	var textTween = create_tween()
	textTween.tween_property(value, "position:y", value.position.y - 20, 0.5)
	textTween.tween_property(value, "modulate:a", 0.0, 0.5)
	textTween.finished.connect(func(): value.queue_free())

func _on_data_hp_changed(hp: int, change: int) -> void:
	var hit_text: Label = HIT_TEXT.instantiate()
	hit_text.text = str(abs(change))
	hit_text.modulate = Color.WHITE

	# add to the scene root instead of as a child of this button
	get_tree().root.add_child(hit_text)

	# convert the position to global coordinates
	var global_text_pos = global_position + Vector2(size.x * 0.5, -4)
	hit_text.global_position = global_text_pos

	if sign(change) == -1:
		recoil()

	# hit text tweening up
	text_tween_up(hit_text)

	# player + enemy hurt tween
	recoil()

## 
func _on_data_defend(defense: int, change: int) -> void:
	var defend_text: Label = HIT_TEXT.instantiate()
	defend_text.text = str(abs(change))
	defend_text.modulate = Color.BLUE
	add_child(defend_text)
	#defend_text.position = Vector2(size.x * 0.5, -4)

	if sign(change) == -1:
		defend()

	# hit text tweening up
	text_tween_up(defend_text)
	
	# player + enemy defend
	defend()
	
func _on_data_defeated() -> void:
	pass

func _on_data_acting() -> void:
	action_slide()
