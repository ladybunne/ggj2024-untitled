class_name CameraShyBug
extends BugEntity

@export var movement: CameraShyBugMovement

func give_player_ref(p_player: Player):
	super(p_player)
	movement.camera = p_player.find_child("Camera2D") as Camera2D
