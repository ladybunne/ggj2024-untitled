# Camera shy bug runs away from the centre of the camera
class_name CameraShyBugMovement extends CharacterBody2D

const SPEED = 400.0
# The bug will try to run at least this far away from the camera centre
const DISTANCE_FROM_CENTRE = 600.0
# The bug will run away at maximum speed at this distance
const MIN_DISTANCE_FROM_CENTRE = 400.0
# The bug will run towards the character at maximum speed at this distance
const MAX_DISTANCE_FROM_CENTRE = 700.0

# Activate bug movement when this distance from the player
const ACTIVATE_DISTANCE = 1000.0

var camera: Camera2D
var platformer_character: PlatformerCharacter
var activated: bool
var chase: bool

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func interval_map(x:float, x1: float, x2: float, y1: float, y2: float):
	var gradient = (y2 - y1) / (x2 - x1)
	return (x - x1) * gradient + y1

func _ready():
	chase = false
	activated = false

func _physics_process(delta):
	var me = global_position.x
	var other = camera.get_screen_center_position().x
	var distance = absf(me - other)
	
	if chase:
		# Lock y to player so they are always accessible
		global_position.y = platformer_character.global_position.y
		if camera:
			# Run away from the camera but also towards the player
			var sign = 1.0
			if me < other:
				sign = -1.0
			if distance < DISTANCE_FROM_CENTRE:
				if distance < MIN_DISTANCE_FROM_CENTRE:
					velocity.x = sign * SPEED
				else:
					velocity.x = sign * SPEED * interval_map(distance, MIN_DISTANCE_FROM_CENTRE, DISTANCE_FROM_CENTRE, 1.0, 0.0)
			elif distance > MAX_DISTANCE_FROM_CENTRE:
				velocity.x = -sign * SPEED
			else:
				velocity.x = -sign * SPEED * interval_map(distance, DISTANCE_FROM_CENTRE, MAX_DISTANCE_FROM_CENTRE, 0.0, 1.0)

	if !activated:
		if distance <= ACTIVATE_DISTANCE:
			activated = true
			chase = true

	move_and_slide()

func begin_chase():
	chase = true

func on_start_dialogue():
	# Stop moving around
	velocity.x = 0
	chase = false
