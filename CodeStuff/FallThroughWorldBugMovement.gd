class_name FallThroughWorldBugMovement extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var enableGravity = false;

@export var terrain: FallthroughTerrain

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and enableGravity:
		velocity.y += gravity * delta
	
	move_and_slide()

func toggleTerrainCollision():
	if terrain != null:
		terrain.toggleCollision()
