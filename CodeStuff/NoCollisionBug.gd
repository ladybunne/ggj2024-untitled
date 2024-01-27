# NoCollision bug is lonely because they can't get to their
# partner as everything just goes through them.
extends BugEntity

func _ready():
	super._ready()
	print("Init NoCollisionBug")
	collision_area.body_entered.connect(body_entered)

func body_entered(target):
	print(target, "yay goal satisfied.")
	if target.is_in_group("Partners"):
		print(target, "Yay. goal! satisfied!")
