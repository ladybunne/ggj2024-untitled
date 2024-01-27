extends Area2D
class_name DialogueTriggerZone
@export var dialogue_to_trigger: DialogueData
@export var one_shot: bool = true

@export var dialogue_manager: DialogueManager

func _enter_tree():
	dialogue_manager = get_tree().get_first_node_in_group("DialogueManager")
	pass

func _on_body_entered(body):
	dialogue_manager.data = dialogue_to_trigger
	#if one_shot then delete this area.
	pass # Replace with function body.
