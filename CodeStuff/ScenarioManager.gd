class_name ScenarioManager extends Node

var points: int = 0

@export var points_required: int = 1
@export var scenario_root_node: Node
@export var invisible_wall: StaticBody2D
@export var new_camera_x_limit: int
@export var autocomplete: bool
@export var autocomplate_player_start: int

# Third scenario specific
@export var door_area: Area2D
@export var room_colliders: StaticBody2D

var goal_satisfied_bugs: Array[BugEntity]
var player: Player
var camera: Camera2D

var inside_door_area: bool = false

var scene_controller: SceneController

signal goal_satisfied(p_bug_name: String)
signal scenario_finished


func _ready():
	# Get all bugs in the scenario and wire them up to this scenario manager's
	# goal satisfied function.
	for bug_uncasted in get_tree().get_nodes_in_group("BugGroup"):
		if not scenario_root_node.is_ancestor_of(bug_uncasted):
			continue
		var bug := bug_uncasted as BugEntity
		if bug == null:
			continue
		if not bug.is_goal_bug:
			continue
		bug.goal_satisfied.connect(on_goal_satisfied)
		print(self, " goal bug: ", bug)
	player = get_tree().get_first_node_in_group("Player")
	if player != null:
		camera = player.find_child("Camera2D") as Camera2D
	if autocomplete:
		# Start with this scenario already completed
		on_scenario_finished()
		var platformer_character = player.find_child("PlatformerCharacter") as PlatformerCharacter
		platformer_character.global_position.x = autocomplate_player_start

func on_goal_satisfied(p_bug_entity: BugEntity):
	if goal_satisfied_bugs.has(p_bug_entity):
		return
	goal_satisfied_bugs.append(p_bug_entity)
	goal_satisfied.emit(p_bug_entity.bug_data.identity.name)
	points += 1
	if points == points_required:
		on_scenario_finished()
		
func on_scenario_finished():
	print("finished!")
	scenario_finished.emit()
	AudioManager.play_sfx("Yes-bongo")
	if invisible_wall != null:
		# Disable collisions
		invisible_wall.collision_layer = 0
	if camera != null:
		camera.limit_right = new_camera_x_limit

func _input(event):
	if event.is_action_pressed("player_interact") and inside_door_area:
		print("player interacted inside door")
		# toggle visibility of world
		get_viewport().set_canvas_cull_mask_bit(9, !get_viewport().get_canvas_cull_mask_bit(9))
		room_colliders.set_collision_layer_value(0, true)
		
func on_door_entered(node):
	print("Entered house: ", node)
	if node is PlatformerCharacter:
		inside_door_area = true
	
func on_door_exited(node):
	if node is PlatformerCharacter:
		inside_door_area = false
