class_name SceneController extends Node

@export var player: Player
var platformer_character: PlatformerCharacter

@export var dialogue_ui: DialogueUI
@export var dialogue_manager: DialogueManager

func _ready():
	platformer_character = player.platformer_character
	
	# Grab all bugs and listen for goal_completion
	
	# Give all bugs a reference to player
	get_tree().call_group("BugGroup", "give_player_ref", platformer_character)
	pass
	
	# Connect the DialogueManager and the Dialogue UI.
	if dialogue_manager != null:
		# A lot of this feels wrong. We may need to revisit.
		#dialogue_manager.scene_started.connect(game_ui.dialogue_ui.on_scene_started)
		#dialogue_manager.dialogue_changed.connect(game_ui.dialogue_ui.on_dialogue_changed)
		#dialogue_manager.dialogue_changed.connect(game_ui.dialogue_ui.dialogue_box.update_ui)
		#dialogue_manager.dialogue_changed.connect(on_dialogue_changed)
		#dialogue_manager.dialogue_done.connect(game_ui.dialogue_ui.on_dialogue_done)
		#dialogue_manager.dialogue_done.connect(on_dialogue_done)
		#game_ui.dialogue_ui.advance_button.pressed.connect(advance_dialogue)
		#game_ui.dialogue_ui.skip_button.pressed.connect(skip_dialogue)
		#dialogue_manager.on_scene_started()
		#dialogue_manager.on_dialogue_changed()
		pass

func advance_dialogue():
	dialogue_manager.advance()
	
func skip_dialogue():
	# This is probably a terrible way of doing this, but whatever.
	# It also needs to output all the lines of the dialogue to History, otherwise
	# skipped cutscenes would be missed, and that's bad.
	#game_ui.dialogue_ui.on_dialogue_done()
	on_dialogue_done()

func on_dialogue_changed(p_line: String, _p_done: bool):
	#ui_state = UIState.DIALOGUE
	if p_line.begins_with("[sp="):
		p_line = p_line.substr(6)
	
	# This is terrible. Also there's a bug with the first message being added
	# as "Author: " rather than the proper author.
	#var history_line = game_ui.dialogue_ui.dialogue_box.speaker_label.text + ": " + p_line
	#HistoryManager.add_message(history_line, "Dialogue")

func on_dialogue_done():
	#ui_state = UIState.NORMAL
	pass

func on_bug_goal_completed():
	# Logic
	pass
