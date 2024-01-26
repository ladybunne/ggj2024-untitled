extends BugEntity

@export var character_body: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Init Elder bug")
	# TEMP: this should be triggered when we talk to him but for
	# 		now I just activate it immediately
	character_body.is_following = true 

func give_player_ref(p_player: PlatformerCharacter):
	super(p_player)
	character_body.player = p_player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
