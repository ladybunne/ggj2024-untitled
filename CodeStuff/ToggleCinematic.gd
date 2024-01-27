class_name ToggleCinematic extends BugEntity

func _input(event):
	super._input(event)
	if platformer_inside != null and event.is_action_pressed("player_interact"):
		scene_controller.toggle_letterboxing()
