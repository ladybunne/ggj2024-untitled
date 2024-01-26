extends BugEntity

@export var character_body: CharacterBody2D

func _ready():
	super._ready()
	print("Init Elder bug")
	character_body.is_following = false 

func give_player_ref(p_player: PlatformerCharacter):
	super(p_player)
	character_body.player = p_player

func _input(event):
	super._input(event)
	if player_inside != null and event.is_action_pressed("player_interact"):
		print("Interacted with ElderBug")
		character_body.is_following = true
