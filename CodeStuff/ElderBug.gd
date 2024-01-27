extends BugEntity

@export var character_body: CharacterBody2D

func _ready():
	super._ready()
	print("Init Elder bug")
	character_body.is_following = false 

func give_player_ref(p_player: Player):
	super(p_player)
	character_body.platformer_character = p_player.platformer_character

func _input(event):
	super._input(event)
	if platformer_inside != null and event.is_action_pressed("player_interact"):
		print("Interacted with ElderBug")
		character_body.is_following = true
