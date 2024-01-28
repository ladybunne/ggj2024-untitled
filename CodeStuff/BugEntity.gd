class_name BugEntity extends Entity

@export var bug_data: BugData

@export var collision_area: Area2D

## The root node of the Bug scene. Please wire this up manually!
@export var root_node: Node2D

signal goal_satisfied(p_bug_entity: BugEntity)
signal start_dialogue(p_bug_data: BugData)

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

@export var show_talk_prompt: bool = true
@export var show_name_label: bool = true
@export var name_label_string: String = "Bug Display Name"

@export var is_goal_bug: bool = false

@export var sound_on_interact: String
@export var sound_on_pickup: String
@export var sound_on_drop: String

@export var y_death_barrier: float = 800.0
var original_global_position: Vector2

@export var needs_to_go_on_ship: bool = false
var ship_area: Area2D
var ship_area_rectangle: Rect2

func _ready():
	if collision_area != null:
		collision_area.body_entered.connect(player_entered)
		collision_area.body_exited.connect(player_exited)
	
	if show_talk_prompt:
		talk_prompt = TALK_PROMPT_SCENE.instantiate()
		root_node.add_child.call_deferred(talk_prompt)
		talk_prompt.visible = false
		(func(): talk_prompt.position = Vector2(-(talk_prompt.size.x / 2) + 16, -64)).call_deferred()
	
	if show_name_label:
		name_label = NAME_LABEL_SCENE.instantiate()
		root_node.add_child.call_deferred(name_label)
		name_label.label.text = name_label_string
		(func(): name_label.position = Vector2(-(name_label.size.x / 2) + 16, -32)).call_deferred()
	
	original_global_position = root_node.global_position
	
	if needs_to_go_on_ship:
		ship_area = get_tree().get_first_node_in_group("ShipArea") as Area2D
		var collision_shape = get_tree().get_first_node_in_group("ShipAreaRectangle") as CollisionShape2D
		ship_area_rectangle = collision_shape.shape.get_rect()

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
		if talk_prompt != null:
			talk_prompt.visible = true
		
func player_exited(body: Node2D):
	var platformer_exited := body as PlatformerCharacter
	if platformer_exited != null:
		platformer_inside = null
		player.currently_colliding_with_bug = null
		if talk_prompt != null:
			talk_prompt.visible = false

func picked_up():
	if sound_on_pickup.length():
		AudioManager.play_sfx(sound_on_pickup)

func dropped():
	if sound_on_drop.length():
		AudioManager.play_sfx(sound_on_drop)
	if needs_to_go_on_ship and is_goal_bug and ship_area_rectangle != null:
		# Sorry for this
		var global_rectangle = Rect2(ship_area.global_position, ship_area_rectangle.size)
		print(global_rectangle)
		print(root_node.global_position)
		if global_rectangle.has_point(root_node.global_position):
			on_goal_satisfied()
			root_node.visible = false

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
	start_dialogue.emit(bug_data)
	if sound_on_interact.length():
		AudioManager.play_sfx(sound_on_interact)
	if talking_completes_goal: 
		on_goal_satisfied()

func on_goal_satisfied():
	goal_satisfied.emit(self)

func _process(delta):
	# Check if bug has fallen off the end of the world
	if root_node.global_position.y > y_death_barrier:
		root_node.global_position = original_global_position
