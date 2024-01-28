class_name ElderBug extends BugEntity

@export var character_body: CharacterBody2D
var dialogue_change_trigger_area: Area2D
var target_area: Area2D
@export var alternate_dialogue: Array[DialogueData]
@export_multiline var dialogue_notes: String
signal spoke_to_elder

func _ready():
	super._ready()
	dialogue_change_trigger_area = get_tree().get_first_node_in_group("ElderBugTrigger")
	dialogue_change_trigger_area.connect("body_entered", change_dialogue_on_that_dialogue_trigger_thing)
	target_area = get_tree().get_first_node_in_group("ElderBugTarget")
	target_area.connect("body_entered", target_area_entered)
	print(dialogue_change_trigger_area.name)	
	print("Init Elder bug")
	character_body.is_following = false 

func change_dialogue_on_that_dialogue_trigger_thing(hopefully_this: Node2D):
	print(hopefully_this.name)
	if hopefully_this == character_body:
		bug_data.dialogue = alternate_dialogue[0]
		print("things changed")

func set_alternate_dialogue(p_index: int):
	bug_data.dialogue = alternate_dialogue[p_index]
	print("ElderBug dialogue set to alternate #" + str(p_index))

func target_area_entered(object: Node2D):
	# This is the ElderBugExtendingBase node, we are interested if its parent
	# ElderBug enters the target area
	if object == get_parent():
		goal_satisfied.emit(self)
		character_body.is_following = false
		character_body.velocity.x = 0

func give_player_ref(p_player: Player):
	super(p_player)
	character_body.platformer_character = p_player.platformer_character

func _input(event):
	super._input(event)
	if platformer_inside != null and event.is_action_pressed("player_interact"):
		character_body.is_following = true

func _process(delta):
	super._process(delta)
	#talk_prompt.position = character_body.position - Vector2(talk_prompt.size.x / 2, 64)

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
