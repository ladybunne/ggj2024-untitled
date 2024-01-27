@tool
extends Area2D
class_name DialogueTriggerZone
@export var dialogue_to_trigger: DialogueData
@export var one_shot: bool = true
@export var dialogue_manager: DialogueManager
@export var collision_shape: CollisionShape2D
var zone_width: float = 50
var zone_height: float = 50

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
	pass

func _on_body_entered(body):
	dialogue_manager.data = dialogue_to_trigger
	if one_shot:
		queue_free()
	pass # Replace with function body.
