class_name PlatformerComponent
extends Resource

## PlatformerComponents do their own vector maths in a vacuum,
## then the PlatformerCharacter combines them nicely.
var vector: Vector2 = Vector2.ZERO

var grid_width: int = 1
var grid_height: int = 1

# This gets called by PlatformerCharacter for each component.
func process(p_delta: float, p_character: PlatformerCharacter) -> Vector2:
	update_vector(p_delta, p_character)
	return vector

# Individual components override this to change [code]vector[/code].
func update_vector(p_delta: float, p_character: PlatformerCharacter) -> void:
	pass

func reset_vector() -> void:
	vector = Vector2.ZERO
