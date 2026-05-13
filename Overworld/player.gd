class_name Player extends CharacterBody2D

enum {
	MOVE
}

const SPEED_WALK = 128 
const SPEED_RUN = 192

var direction: Vector2 = Vector2.ZERO
var input_vector = Vector2.ZERO
var state = MOVE

var is_running = false #temp variable 

# @onready var textbox_handler = get_node("../Textbox") as textboxHandler
# @onready var textbox_handler = get_node("/root/Textbox")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
# below is the state machine that mother encore uses. this is done so that you dont write parameters playback a bunch im assuming
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var sprite: Sprite2D = $Sprite2D

@export var paused: bool = false
@export var no_collision: bool

signal game_pause
signal game_unpause

func _ready():
	#PlayerVariables.player = self
	#global_position = Vector2(PlayerVariables.xpos, PlayerVariables.ypos)
	animation_tree.active = true
	
	# player spawns facing down
	direction = Vector2(0,1)

func _process(_delta):
	if can_move():
		input_vector = Input.get_vector("left","right","up","down").normalized()
	else:
		input_vector = Vector2.ZERO
		direction = Vector2.ZERO

	direction = input_vector
	update_animation_parameters()

func _physics_process(_delta):
	match state:
		MOVE:
			move_state(_delta)
	
func move_state(_delta):
	if !paused:
		_movement(_delta)

func _movement(_delta):
	if input_vector != Vector2.ZERO:
		move()
		#running logic can be inserted here later
	else:
		velocity = Vector2.ZERO

	# velocity = velocity * _delta * (SPEED_WALK/1.7)
	move_and_slide()

	position = round_vector(position)

## sets velocity for movimiento
func move():
	if is_running == true:
		velocity = direction * SPEED_WALK
	else:
		velocity = input_vector * SPEED_WALK

	if input_vector != Vector2.ZERO:
		direction = input_vector

## this is for rounding the position to the nearest pixel during overworld movement, in order to prevent jittering
func round_vector(pos: Vector2) -> Vector2:
	pos.x = round(pos.x)
	pos.y = round(pos.y)
	return pos

# might remove this func later....
func can_move() -> bool:
	# if textbox_handler == null: # dirty fix
	# 	return true
	
	# #TODO: maybe reuse state enum in the return statement?
	# return textbox_handler.current_state == textboxHandler.State.IDLE \
	# 	and textbox_handler.text_queue.size() == 0
	return true

# is this even necessary still?
# maybe add on to it if still in use
func pause() -> void:
	state = MOVE
	paused = true
	input_vector = Vector2.ZERO
	pass

func update_animation_parameters():
	if(direction == Vector2.ZERO):
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true

	# if(Input.is_action_pressed("shift")):
	# 	animation_tree["parameters/conditions/run"] = true
	# else:
	# 	animation_tree["parameters/conditions/run"] = false

	if(direction != Vector2.ZERO):
		animation_tree["parameters/idle/blend_position"] = direction
		animation_tree["parameters/walk/blend_position"] = direction
		animation_tree["parameters/run/blend_position"] = direction
	
