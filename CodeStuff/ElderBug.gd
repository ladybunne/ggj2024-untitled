extends BugEntity

@export var character_body: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Init Elder bug")
	character_body.is_following = true

func give_player_ref(p_player: PlatformerCharacter):
	super(p_player)
	character_body.player = p_player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if character_body.is_following:
		#print("Following player...")
