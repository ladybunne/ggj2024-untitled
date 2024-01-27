class_name RemoveBackground extends BugEntity

var inside_house: bool = false

func _ready():
	super._ready()
	var house: Area2D = get_tree().get_first_node_in_group("House")
	house.connect("body_entered", toggle_inside)
	house.connect("body_exited", toggle_outside)

func toggle_inside(node):
	print("Entered house body")
	inside_house = true

func toggle_outside(node):
	inside_house = false

func _input(event):
	super._input(event)
	if platformer_inside != null and event.is_action_pressed("player_interact"):
		toggle_remove_background.call_deferred()

func toggle_remove_background():
	if scene_controller.ui_state != scene_controller.UIState.DIALOGUE:
		return
	# Toggle canvas layer 5 (background) on/off
	
	# if outside of house
	if inside_house:
		get_viewport().set_canvas_cull_mask_bit(7, !get_viewport().get_canvas_cull_mask_bit(7))
	else:
		get_viewport().set_canvas_cull_mask_bit(4, !get_viewport().get_canvas_cull_mask_bit(4))
