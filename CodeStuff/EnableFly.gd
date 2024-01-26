class_name EnableFly extends BugEntity

@export var flyComponent: Fly
@export var flying_enabled: bool = false
var jump_component_cache: JumpComponent = null

func _input(event):
	super._input(event)
	if player_inside != null and event.is_action_pressed("player_interact"):
		if flying_enabled:
			flying_enabled = false
			player.jump_component = jump_component_cache
			jump_component_cache = null
		else:
			jump_component_cache = player.jump_component
			player.jump_component = flyComponent
			flying_enabled = true
