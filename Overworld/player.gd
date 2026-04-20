class_name Player extends CharacterBody2D

enum{
	IDLE,
	MOVE
}

var direction: Vector2 = Vector2.ZERO
var inputVector = Vector2.ZERO

const speed_walk = 128 
const speed_run = 128
var state = MOVE

var run = false #temp variable 
var paused: bool = false # temp variable, fix this later with a proper pause menu

@onready var tbHandler = get_node("../Textbox") as textboxHandler
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
# below is the state machine that mother encore uses. this is done so that you dont write parameters playback a bunch im assuming
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	PlayerVariables.player = self
	transform.origin = Vector2(PlayerVariables.xpos, PlayerVariables.ypos)
	pass

func _process(_delta):
	animation_tree.active = true

func _process(delta):
	update_animation_parameters()

	if canMove():
		inputVector = Input.get_vector("left","right","up","down").normalized()
	else:
		inputVector = Vector2.ZERO
		direction = Vector2.ZERO

	direction = inputVector
	
func _physics_process(_delta):
	match state:
		MOVE:
			move_state(delta)

# CHECK IF THIS FUNCTION IS EVEN NECESSARY
# future brad: it is necessary for textbox handling. add back later
func canMove() -> bool: 
	if tbHandler == null: #temp fix
		return true # temp fix
	return tbHandler.currentState == 0 && tbHandler.textQueue.size() == 0 # 0 == IDLE
	
func move_state(delta):
	if !paused:
		_movement(delta)

func _movement(delta):
	if inputVector != Vector2.ZERO:
		move()
		move_and_slide()
		position = round_vector(position)
	else:
		velocity = Vector2.ZERO

func move():
	if run:
		pass
	else:
		velocity = inputVector * speed_walk
		
		#animation_state.travel("walk")
		
	if inputVector != Vector2.ZERO:
		direction = inputVector

'''this is for rounding the position to the nearest pixel, this is done to prevent jittering when moving at low speeds'''
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
	