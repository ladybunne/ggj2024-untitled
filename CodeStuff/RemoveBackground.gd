class_name RemoveBackground extends BugEntity

func _input(event):
	super._input(event)
	if platformer_inside != null and event.is_action_pressed("player_interact"):
		# Toggle canvas layer 1 (background) on/off
		get_viewport().canvas_cull_mask ^= 1
