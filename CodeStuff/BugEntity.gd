class_name BugEntity extends Entity

@export var bug_data: BugData

@export var collision_area: Area2D

## The root node of the Bug scene. Please wire this up manually!
@export var root_node: Node2D

signal goal_satisfied(p_bug_entity: BugEntity)
signal start_dialogue(p_bug_entity: BugEntity)

var platformer_inside: PlatformerCharacter

# Scene controller gives every bug a ref to the player
var player: Player
var platformer_character: PlatformerCharacter
var scene_controller: SceneController

const TALK_PROMPT_SCENE: PackedScene = preload("res://Scenes/UI/TalkPrompt.tscn")
var talk_prompt: Control

const NAME_LABEL_SCENE: PackedScene = preload("res://Scenes/UI/NameLabel.tscn")
var name_label: Control

@export var talking_completes_goal: bool = false

@export var name_label_string: String = "Bug Display Name"

func _ready():
	if collision_area != null:
		collision_area.body_entered.connect(player_entered)
		collision_area.body_exited.connect(player_exited)
	
	talk_prompt = TALK_PROMPT_SCENE.instantiate()
	root_node.add_child.call_deferred(talk_prompt)
	talk_prompt.visible = false
	(func(): talk_prompt.position = Vector2(-(talk_prompt.size.x / 2) + 16, -64)).call_deferred()
	
	name_label = NAME_LABEL_SCENE.instantiate()
	root_node.add_child.call_deferred(name_label)
	name_label.label.text = name_label_string
	(func(): name_label.position = Vector2(-(name_label.size.x / 2) + 16, -32)).call_deferred()

func give_player_ref(p_player: Player):
	player = p_player
	platformer_character = p_player.platformer_character
	
func give_scene_controller_ref(p_scene_controller: SceneController):
	scene_controller = p_scene_controller
	
func player_entered(body: Node2D):
	var platformer_entered := body as PlatformerCharacter
	if platformer_entered != null:
		platformer_inside = platformer_entered
		player.currently_colliding_with_bug = self
		talk_prompt.visible = true
		
func player_exited(body: Node2D):
	var platformer_exited := body as PlatformerCharacter
	if platformer_exited != null:
		platformer_inside = null
		player.currently_colliding_with_bug = null
		talk_prompt.visible = false

func picked_up():
	pass

func dropped():
	pass

func _input(event):
	if platformer_inside == null:
		return
	# Need to check the dialogue state.
	if event.is_action_pressed("player_interact"):
		if scene_controller.ui_state == scene_controller.UIState.DIALOGUE:
			return 
		if bug_data == null:
			return
		on_start_dialogue()

func on_start_dialogue():
	start_dialogue.emit(self)
	if talking_completes_goal: 
		on_goal_satisfied()

func on_goal_satisfied():
	goal_satisfied.emit(self)
