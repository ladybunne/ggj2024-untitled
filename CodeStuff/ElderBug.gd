class_name ElderBug extends BugEntity

@export var character_body: CharacterBody2D
var dialogue_change_trigger_area: Area2D
@export var alternate_dialogue: DialogueData
signal spoke_to_elder

func _ready():
	super._ready()
	dialogue_change_trigger_area = get_tree().get_first_node_in_group("ElderBugTrigger")
	dialogue_change_trigger_area.body_entered.connect(change_dialogue)
	print("Init Elder bug")
	character_body.is_following = false 

func change_dialogue():
	bug_data.dialogue = alternate_dialogue

func give_player_ref(p_player: Player):
	super(p_player)
	character_body.platformer_character = p_player.platformer_character

func _input(event):
	super._input(event)
	if platformer_inside != null and event.is_action_pressed("player_interact"):
		character_body.is_following = true

func _process(delta):
	talk_prompt.position = character_body.position - Vector2(talk_prompt.size.x / 2, 64)

func picked_up():
	super.picked_up()
	# Enable this for crimes.
	#character_body.position = root_node.position
	character_body.position = Vector2.ZERO
	character_body.process_mode = Node.PROCESS_MODE_DISABLED

func dropped():
	super.dropped()
	#character_body.position = root_node.position
	character_body.position = Vector2.ZERO
	character_body.process_mode = Node.PROCESS_MODE_INHERIT
