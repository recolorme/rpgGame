extends Node2D

#var overworld_scene: PackedScene = load("res://Overworld/Overworld.tscn")
#var battle_scene: PackedScene = load("res://Battle/battle.tscn")
#
#var reserved_scene: Node
#var current_scene: Node
#var is_in_world: bool = true


func _ready() -> void:
	#current_scene = overworld_scene.instantiate()
	# add_child(current_scene)
	#reserved_scene = battle_scene.instantiate()
	## do not add as child yet - just hold in reserve!
	pass


func _process(delta: float) -> void:
	pass

#func switch_scenes() -> void:
	#var scene: Node = current_scene
	#remove_child(current_scene)
	#current_scene = reserved_scene
	#reserved_scene = scene
	#add_child(reserved_scene)
	#is_in_world = !is_in_world
	
	
