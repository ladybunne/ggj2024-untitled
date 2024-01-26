# Elder Bug's physics is just an arcade physics style which
# has gravity and tries to follow the 
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var player: PlatformerCharacter

# Indicates whether the Elder bug is trying to follow the player
var is_following = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if is_following and player:
		print("Following player with translation")
		print(player.position)
		var target = player.position
		#var bug

	move_and_slide()
