# Camera shy bug runs away from the centre of the camera
class_name CameraShyBugMovement extends CharacterBody2D

const SPEED = 400.0
# The bug will try to run at least this far away from the camera centre
const DISTANCE_FROM_CENTRE = 400.0
# The bug will run away at maximum speed at this distance
const MIN_DISTANCE_FROM_CENTRE = 200.0

var camera: Camera2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func interval_map(x:float, x1: float, x2: float, y1: float, y2: float):
	var gradient = (y2 - y1) / (x2 - x1)
	return (x - x1) * gradient + y1

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if camera:
		# Run away from the camera
		var me = global_position.x
		var other = camera.get_screen_center_position().x
		var distance = absf(me - other)
		var sign = 1.0
		if me < other:
			sign = -1.0
		if distance < DISTANCE_FROM_CENTRE:
			if distance < MIN_DISTANCE_FROM_CENTRE:
				velocity.x = sign * SPEED
			else:
				velocity.x = sign * SPEED * interval_map(distance, MIN_DISTANCE_FROM_CENTRE, DISTANCE_FROM_CENTRE, 1.0, 0.0)
		else:
			velocity.x = 0

	move_and_slide()
