extends BugEntity

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	print("Init CollisionBoxTooBigBug")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	super._input(event)
	if platformer_inside != null and event.is_action_pressed("player_interact"):
		print("Interacted with CollisionBoxTooBig")
