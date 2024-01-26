class_name RunComponent
extends PlatformerComponent

## The maximum speed (in tiles per second) that the character runs at.
@export_range(0, 1 << 31) var max_speed: float = 12

## The amount of seconds it takes for the character to reach max speed.
## Set to 0 to enable instant acceleration.
@export var acceleration: float = 0

## The amount of seconds it takes for the character to become stationary from max speed.
## Set to 0 to enable instant deceleration.
@export var deceleration: float = 0

# Input names. Set by the PlatformerCharacter this exists on.
var move_left_name: String = ""
var move_right_name: String = ""

func speed() -> float:
	return max_speed * grid_width

# Weird little thing where if your acceleration is slower than your
# deceleration, and you're holding the opposite direction to what
# you're moving, you will actually decelerate [i]slower[i] than if
# you were holding nothing at all. (Nothing at all, nothing at all.)
#
# Stupid sexy physics.
#
# Anyway. The obvious fix is to check if your existing velocity is
# opposite to your input direction, and if so, use the faster of
# acceleration or deceleration.
# 
# What a silly bug.
func update_vector(p_delta: float, p_character: PlatformerCharacter) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction = p_character.input_move.x
	if direction:
		if acceleration > 0:
			vector.x = move_toward(vector.x, direction * speed(), p_delta * max_speed * grid_width / acceleration)
		else: 
			vector.x = direction * speed()
	else:
		if deceleration > 0:
			vector.x = move_toward(vector.x, 0, p_delta * speed() / deceleration)
		else:
			vector.x = 0
