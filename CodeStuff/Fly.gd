class_name Fly
extends JumpComponent

# Version of jump_component where the character just flies around

@export var fly_speed: float = 800.0

func update_vector(p_delta: float, p_character: PlatformerCharacter) -> void:
	if Input.is_action_pressed(jump_name):
		vector.y = -fly_speed
	elif Input.is_action_pressed(move_down_name):
		vector.y = fly_speed
	else:
		vector.y = 0

func apply_gravity(p_delta: float, p_character: PlatformerCharacter, p_is_on_wall: bool):
	jump_velocity = 0


