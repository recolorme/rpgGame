
# incase i mess it up
# var world_scene: PackedScene = load("res://world.tscn")
# var battle_scene: PackedScene = load("res://battle.tscn")

# var reserved_scene: Node
# var current_scene: Node
# var is_in_world: bool = true

# func _ready() -> void:
#     current_scene = world_scene.instantiate()
#     add_child( current_scene )
#     reserved_scene = battle_scene.instantiate()
#     ## do not add as child yet - just hold in reserve!

# func switch_scenes() -> void:
#     var scene: Node = current_scene
#     remove_child(current_scene)
#     current_scene = reserved_scene
#     reserved_scene = scene
#     add_child(reserved_scene)
#     is_in_world = !is_in_world
