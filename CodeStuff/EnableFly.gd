class_name EnableFly extends BugEntity

@export var flyComponent: Fly 

func _input(event):
	super._input(event)
	if player_inside != null and event.is_action_pressed("player_interact"):
		player.jump_component = flyComponent
