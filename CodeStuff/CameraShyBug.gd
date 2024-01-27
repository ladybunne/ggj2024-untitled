class_name CameraShyBug
extends BugEntity

@export var movement: CameraShyBugMovement

func give_player_ref(p_player: Player):
	super(p_player)
	movement.camera = p_player.find_child("Camera2D") as Camera2D

func picked_up():
	super.picked_up()
	# Enable this for crimes.
	#movement.position = root_node.position
	movement.position = Vector2.ZERO
	movement.process_mode = Node.PROCESS_MODE_DISABLED

func dropped():
	super.dropped()
	#movement.position = root_node.position
	movement.position = Vector2.ZERO
	movement.process_mode = Node.PROCESS_MODE_INHERIT
