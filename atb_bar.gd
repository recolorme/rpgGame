class_name ATBBar extends ProgressBar

signal filled()

const SPEED_BASE: float = 0.25

func _ready() -> void:
	value = randf_range(min_value,max_value * 0.75)

func _process(_delta: float) -> void:
	value += SPEED_BASE
	
	if is_equal_approx(value, max_value):
		#get_theme_stylebox("fill").bg_color = Color("ffffff")
		modulate = Color("ffffff")
		set_process(false)
		filled.emit()
		#TODO begin animation.
