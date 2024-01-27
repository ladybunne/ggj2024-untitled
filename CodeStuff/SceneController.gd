class_name SceneController extends Node

@export var player: Player
var platformer_character: PlatformerCharacter

@export var dialogue_ui: DialogueUI
@export var dialogue_manager: DialogueManager

## This is to control the state of the game, when transitioning between things
## like the normal view, a tutorial popup, a dialogue instance, a choice, and so on.
enum UIState {NORMAL, DIALOGUE}

## The current state of the UI.
@export var ui_state: UIState = UIState.NORMAL


func _ready():
	platformer_character = player.platformer_character
	
	# Grab all bugs and listen for goal_completion
	
	# Give all bugs a reference to player
	for bug_uncasted in get_tree().get_nodes_in_group("BugGroup"):
		var bug := bug_uncasted as BugEntity
		if bug == null:
			continue
		bug.give_player_ref(player)
		bug.start_dialogue.connect(func(p_bug: BugEntity): 
			dialogue_ui.set_bug(p_bug)
			dialogue_manager.data = p_bug.bug_data.dialogue
			)
		 
	
	# Connect the DialogueManager and the Dialogue UI.
	if dialogue_manager != null:
		# A lot of this feels wrong. We may need to revisit.
		dialogue_manager.dialogue_changed.connect(dialogue_ui.on_dialogue_changed)
		dialogue_manager.dialogue_changed.connect(dialogue_ui.dialogue_box.update_ui)
		dialogue_manager.dialogue_changed.connect(on_dialogue_changed)
		dialogue_manager.dialogue_done.connect(dialogue_ui.on_dialogue_done)
		dialogue_manager.dialogue_done.connect(on_dialogue_done)
		dialogue_ui.advance_button.pressed.connect(advance_dialogue)
		dialogue_manager.on_scene_started()
		dialogue_manager.on_dialogue_changed()

func advance_dialogue():
	dialogue_manager.advance()
	
func skip_dialogue():
	# This is probably a terrible way of doing this, but whatever.
	# It also needs to output all the lines of the dialogue to History, otherwise
	# skipped cutscenes would be missed, and that's bad.
	#game_ui.dialogue_ui.on_dialogue_done()
	on_dialogue_done()

func on_dialogue_changed(p_line: String, _p_done: bool):
	ui_state = UIState.DIALOGUE

func on_dialogue_done():
	ui_state = UIState.NORMAL
	pass

func on_bug_goal_completed():
	# Logic
	pass

func _input(event):
	if event.is_action_pressed("player_jump") and ui_state == UIState.DIALOGUE:
		advance_dialogue()
	
	# Debug stuff below this line!
	if not OS.is_debug_build():
		return
	
	if event is InputEventKey and event.pressed:
		# Reload the scene.
		if event.keycode == KEY_R:
			get_tree().reload_current_scene()
