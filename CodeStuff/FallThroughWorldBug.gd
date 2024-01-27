class_name FallThroughWorldBug extends BugEntity

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	print("Init FallThroughWorld bug")

func _input(event):
	super._input(event)
	if platformer_inside != null and event.is_action_pressed("player_interact"):
		var body = root_node as FallThroughWorldBugMovement
		if body != null:
			body.enableGravity = !body.enableGravity
			# Toggle collisions with the floor
			body.collision_mask ^= 1
			body.toggleTerrainCollision()
			goal_satisfied.emit(self)
