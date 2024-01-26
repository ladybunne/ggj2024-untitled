class_name SceneController extends Node

@export var player: PlatformerCharacter

func _ready():
	# Grab all bugs and listen for goal_completion
	
	# Give all bugs a reference to player
	get_tree().call_group("BugGroup", "give_player_ref", player)
	pass
	
func on_bug_goal_completed():
	# Logic
	pass
