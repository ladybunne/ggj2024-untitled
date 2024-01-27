class_name Player extends Entity

@export var pickup_enabled: bool = true

@export_group("Internal")
@export var platformer_character: PlatformerCharacter
@export var camera: Camera2D
@export_group("")

@export_group("References")
@export var level_ref: Node2D
@export_group("")

@export var y_death_barrier: float = 5000.0

var currently_colliding_with_bug: BugEntity
var currently_held_bug: BugEntity
var start_position: Vector2

func _ready():
	start_position = platformer_character.global_position

func _input(event):
	if event.is_action_pressed("player_pick_up") and pickup_enabled:
		# Drop a bug if we have one already.
		if currently_held_bug != null:
			#print("dropped bug: " + currently_held_bug.to_string())
			currently_held_bug.dropped()
			currently_held_bug.root_node.reparent(level_ref)
			currently_held_bug.root_node.scale.y = 1
			currently_held_bug.root_node.position = platformer_character.position + Vector2(32, 32)
			currently_held_bug = null
		# Pick up a bug if we're colliding with it.
		else:
			if currently_colliding_with_bug == null:
				return
			currently_held_bug = currently_colliding_with_bug
			currently_held_bug.picked_up()
			currently_held_bug.root_node.reparent(platformer_character)
			currently_held_bug.root_node.scale.y = -1
			currently_held_bug.root_node.position = Vector2(0, 0)
			#print("picked up bug: " + currently_held_bug.to_string())

func _process(delta):
	# Update the sprite flipped
	if platformer_character.facing_right:
		platformer_character.get_node("AnimatedSprite2D").flip_h = true
	else:
		platformer_character.get_node("AnimatedSprite2D").flip_h = false

	# Take the current animation state from the platformer controller fsm
	# and swap the animation
	if platformer_character.animation_state == platformer_character.AnimationState.IDLE:
		platformer_character.get_node("AnimatedSprite2D").play("Idle")
	elif platformer_character.animation_state == platformer_character.AnimationState.RUN:
		platformer_character.get_node("AnimatedSprite2D").play("Walking")
	
	# Check if we've fallen off the edge
	if platformer_character.global_position.y > y_death_barrier:
		platformer_character.global_position = start_position
		platformer_character.reset_velocity()
		
