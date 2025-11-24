class_name Player extends CharacterBody2D

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var speed: float = 120.0
var speed_init = speed
var state: String = "idle"

@onready var tbHandler = get_node("../Textbox") as textboxHandler
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D


func _ready():
	pass

func _process(delta):
	direction = Vector2( 
		Input.get_vector("left","right","up","down")) # maybe someday mess with the diagonals again......
	
	if SetState() == true or SetDirection() == true:
		UpdateAnimation()
	
func _physics_process(delta):
	walk()

	velocity = direction * speed

	
	move_and_slide()

func walk():
	if Input.is_action_just_pressed("shift"):
		speed /= 8
	elif Input.is_action_just_released("shift"):
		speed = speed_init

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
	
func SetState() -> bool:
	var new_state: String = "idle" if direction == Vector2.ZERO else "walk"
	if new_state == state:
		return false
	state = new_state
	return true
	
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
		
func canMove() -> bool:
	return tbHandler.currentState == 0 && tbHandler.textQueue.size() == 0 # 0 == IDLE
	
