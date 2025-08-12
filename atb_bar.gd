class_name ATBBar extends ProgressBar

signal filled()

const SPEED_BASE: float = 0.25

@onready var _anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	_anim.play("RESET")
	value = randf_range(min_value, max_value * 0.75)

func reset() -> void:
	modulate = Color.WHITE
	value = min_value
	set_process(true)

func stop() -> void:
	set_process(false)

func _process(_delta: float) -> void:
	value += SPEED_BASE
	
	if is_equal_approx(value, max_value):
		#_anim.play("highlight")
		modulate = Color("34cf00")
		stop()
		filled.emit()
	
