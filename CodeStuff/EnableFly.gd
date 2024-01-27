class_name EnableFly extends BugEntity

@export var flyComponent: Fly
@export var flying_enabled: bool = false
var jump_component_cache: JumpComponent = null

func _input(event):
	super._input(event)
	if platformer_inside != null and event.is_action_pressed("player_interact"):
		if flying_enabled:
			flying_enabled = false
			platformer_character.jump_component = jump_component_cache
			jump_component_cache = null
		else:
			jump_component_cache = platformer_character.jump_component
			platformer_character.jump_component = flyComponent
			flying_enabled = true
