extends BugEntity

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Init FallThroughWorld bug")

func give_player_ref(p_player: PlatformerCharacter):
	super(p_player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
