class_name BugEntity extends Entity

@export var bug_data: BugData

@export var collision_area: Area2D

## The root node of the Bug scene. Please wire this up manually!
@export var root_node: Node2D

signal goal_satisfied
signal start_dialogue(p_bug_entity: BugEntity)

var platformer_inside: PlatformerCharacter

# Scene controller gives every bug a ref to the player
var player: Player
var platformer_character: PlatformerCharacter
var scene_controller: SceneController

func _ready():
	if collision_area != null:
		collision_area.body_entered.connect(player_entered)
		collision_area.body_exited.connect(player_exited)

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
		
func player_exited(body: Node2D):
	var platformer_exited := body as PlatformerCharacter
	if platformer_exited != null:
		platformer_inside = null
		player.currently_colliding_with_bug = null

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
