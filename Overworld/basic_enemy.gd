class_name Enemy extends CharacterBody2D

func _ready() -> void:
	
	pass

func _process(_delta: float) -> void:
	pass


func _on_interact_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("mamaguebo battle")

		# save the player position before transitioning to battle scene
		Global.player_xpos = int(body.global_position.x)
		Global.player_ypos = int(body.global_position.y)
		get_tree().change_scene_to_file.call_deferred("res://Battle/battle.tscn")
