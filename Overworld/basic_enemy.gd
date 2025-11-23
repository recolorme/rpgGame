class_name Enemy extends CharacterBody2D

func _ready() -> void:
	
	pass

func _process(delta: float) -> void:
	pass


func _on_interact_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("mamaguebo")
		#switch_scenes()
