class_name Player extends CharacterBody2D

enum{
	IDLE,
	MOVE
}

# remove maybe?
var cardinal_direction: Vector2 = Vector2.DOWN 
var direction: Vector2 = Vector2.ZERO
var inputVector = Vector2.ZERO

const speed_walk = 64 
const speed_run = 128
var state = MOVE

var run = false #temp variable 
var paused: bool = false # temp value, fix this later with a proper pause menu

@onready var tbHandler = get_node("../Textbox") as textboxHandler
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite: Sprite2D = $Sprite2D


func _ready():
	pass

func _process(delta):
	if canMove():
		direction = Vector2( 
			Input.get_vector("left","right","up","down")) # maybe someday mess with the diagonals again......
	else:
		direction = Vector2.ZERO
	
	if state != null or SetDirection() == true:
		UpdateAnimation()
	
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)

	
	
	#walk()
	#velocity = direction * speed_walk
	#move_and_slide()

#func walk():
	#if Input.is_action_just_pressed("shift"):
		#speed_walk /= 8
	#elif Input.is_action_just_released("shift"):
		#speed_walk = speed_init

func SetDirection() -> bool: 
	var new_dir: Vector2 = cardinal_direction

	if direction == Vector2.ZERO: # Stands still 
		return false

	if abs(direction.y) == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT 
	elif abs(direction.x) == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	if new_dir == cardinal_direction:
		return false

	cardinal_direction = new_dir
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true
	

# this function shouldnt be necessary with the enum

# func SetState() -> bool:
# 	var new_state: String = "idle" if direction == Vector2.ZERO else "walk"
# 	if new_state == state:
# 		return false
# 	state = new_state
# 	return true
	
func UpdateAnimation() -> void:
	animation_player.play(state + "_" + AnimDirection())
	pass

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

# CHECK IF THIS FUNCTION IS EVEN NECESSARY
func canMove() -> bool: 
	if tbHandler == null: #temp fix
		return true # temp fix
	return tbHandler.currentState == 0 && tbHandler.textQueue.size() == 0 # 0 == IDLE
	
func move_state(delta):
	if !paused:
		_movement(delta)

func _movement(delta):
	if inputVector != Vector2.ZERO or run == true:
		move()

func move():
	if run:
		pass
	else:
		velocity = inputVector * speed_walk
		
	if inputVector != Vector2.ZERO:
		direction = inputVector
		
		# bottom is for looking for events...... ignore for now......
		# eventRayCaster.rotation = direction.angle() - TAU/4
		
