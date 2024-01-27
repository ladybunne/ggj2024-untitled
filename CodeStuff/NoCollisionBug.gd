# NoCollision bug is lonely because they can't get to their
# partner as everything just goes through them.
extends BugEntity

func _ready():
	super._ready()
	print("Init NoCollisionBug")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
