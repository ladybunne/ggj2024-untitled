class_name RemoveBackground extends BugEntity

func _input(event):
	super._input(event)
	if platformer_inside != null and event.is_action_pressed("player_interact"):
		toggle_remove_background.call_deferred()

func toggle_remove_background():
	if scene_controller.ui_state != scene_controller.UIState.DIALOGUE:
		return
	# Toggle canvas layer 5 (background) on/off
	get_viewport().set_canvas_cull_mask_bit(4, !get_viewport().get_canvas_cull_mask_bit(4))
