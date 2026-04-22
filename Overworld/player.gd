class_name Player extends CharacterBody2D

enum{
	MOVE
}

var direction: Vector2 = Vector2.ZERO
var input_vector = Vector2.ZERO

const speed_walk = 128 
const speed_run = 192
var state = MOVE

var is_running = false #temp variable 
var paused: bool = false # temp variable, fix this later with a proper pause menu

@onready var tb_handler = get_node("../Textbox") as textboxHandler
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
# below is the state machine that mother encore uses. this is done so that you dont write parameters playback a bunch im assuming
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	# stores player location on the current map
	PlayerVariables.player = self
	transform.origin = Vector2(PlayerVariables.xpos, PlayerVariables.ypos)

	# player spawns facing down
	direction = Vector2(0,1)

func _process(_delta):
	update_animation_parameters()

	if can_move():
		input_vector = Input.get_vector("left","right","up","down").normalized()
	else:
		input_vector = Vector2.ZERO
		direction = Vector2.ZERO

	direction = input_vector
	
func _physics_process(_delta):
	match state:
		MOVE:
			move_state(_delta)

# function for textbox handling. maybe for cutscenes eventually?
func can_move() -> bool: 
	if tb_handler == null: #temp fix
		return true # temp fix
	#TODO: maybe reuse state enum in the return statement?
	return tb_handler.currentState == 0 && tb_handler.textQueue.size() == 0 # 0 == IDLE 
	
func move_state(delta):
	if !paused:
		_movement(delta)

func _movement(_delta):
	if input_vector != Vector2.ZERO:
		move()
		move_and_slide()
		position = round_vector(position)
	else:
		velocity = Vector2.ZERO

func move():
	if is_running:
		pass
	else:
		velocity = input_vector * speed_walk
		#animation_state.travel("walk")
	
	# debug movement values
	print("Input: ", input_vector, " | Velocity: ", velocity, " | Speed: ", velocity.length())

	if input_vector != Vector2.ZERO:
		direction = input_vector

## this is for rounding the position to the nearest pixel during overworld movement, in order to prevent jittering
func round_vector(pos: Vector2) -> Vector2:
	pos.x = round(pos.x)
	pos.y = round(pos.y)
	return pos
		
func update_animation_parameters():
	if(velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true

	if(Input.is_action_pressed("shift")):
		animation_tree["parameters/conditions/run"] = true
	else:
		animation_tree["parameters/conditions/run"] = false

	if(direction != Vector2.ZERO):
		animation_tree["parameters/idle/blend_position"] = direction
		animation_tree["parameters/walk/blend_position"] = direction
		animation_tree["parameters/run/blend_position"] = direction
	
