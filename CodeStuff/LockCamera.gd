class_name LockCamera extends BugEntity

func _input(event):
	super._input(event)
	if platformer_inside != null and event.is_action_pressed("player_interact"):
		toggle_camera_lock.call_deferred()

func toggle_camera_lock():
	if scene_controller.ui_state != scene_controller.UIState.DIALOGUE:
		return 
	var camera = platformer_character.find_child("RemoteTransform2D") as RemoteTransform2D
	if camera != null:
		camera.update_position = !camera.update_position
