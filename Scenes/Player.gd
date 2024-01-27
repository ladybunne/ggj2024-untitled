class_name Player extends Entity

@export_group("Internal")
@export var platformer_character: PlatformerCharacter
@export var camera: Camera2D
@export_group("")

@export_group("References")
@export var level_ref: Node2D
@export_group("")

var currently_colliding_with_bug: BugEntity
var currently_held_bug: BugEntity

func _input(event):
	if event.is_action_pressed("player_pick_up"):
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
