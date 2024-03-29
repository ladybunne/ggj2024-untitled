@tool
class_name DialogueTriggerZone extends Area2D
@export var dialogue_to_trigger: DialogueData
@export var dialogue_owner: Node2D
var bug_data: BugData
@export var one_shot: bool = true
@export var dialogue_manager: DialogueManager
@export var collision_shape: CollisionShape2D

var zone_width: float = 50
var zone_height: float = 50

signal start_dialogue(p_bug_data: BugData)

@export var Zone_Width: float:
	get:
		return zone_width
	set(value):
		zone_width = value
		update_shape()
@export var Zone_Height: float:
	get:
		return zone_height
	set(value):
		zone_height = value
		update_shape()

func update_shape():
	if collision_shape!= null:
		collision_shape.shape.size = Vector2(zone_width,zone_height)

func _ready():
	dialogue_manager = get_tree().get_first_node_in_group("DialogueManager")
	
	if Engine.is_editor_hint():
		return
	
	#TODO get Kara to forgive me for this:
	for thing in dialogue_owner.get_children():
		var bug := thing as BugEntity
		if bug == null:
			continue
		bug_data = bug.bug_data.duplicate()
		bug_data.dialogue = dialogue_to_trigger
		
		#print(thing.name)
		#if thing.has_signal("goal_satisfied"):
			#print(thing.name+" is the forealreal")
			#bug_data = thing.bug_data
			#print("holy shit if this works")

func _on_body_entered(body):
	on_start_dialogue()
	if one_shot:
		queue_free()
	
func on_start_dialogue():
	start_dialogue.emit(bug_data)
