class_name CollisionBoxTooBigBug extends BugEntity

@export var interact_area: Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	print("Init CollisionBoxTooBigBug")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)

func _input(event):
	super._input(event)
