class_name LockCamera extends BugEntity

func _input(event):
	super._input(event)
	if platformer_inside != null and event.is_action_pressed("player_interact"):
		var camera = platformer_character.find_child("RemoteTransform2D") as RemoteTransform2D
		if camera != null:
			camera.update_position = !camera.update_position
