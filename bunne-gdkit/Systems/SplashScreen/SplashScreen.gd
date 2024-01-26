extends Node

@export var next_scene: PackedScene = null

func splash_done():
	if next_scene != null:
		get_tree().change_scene_to_packed(next_scene)
