## Currently a very, very simple implementation of dialogue.
## 
## Usage: get a reference to the DialogueManager, and in [code]_ready()[/code],
## connect the [code]dialogue_changed(line)[/code] signal to your handler function.
## Then call [code]on_dialogue_changed()[/code] to get the first line.
## [br][br]
## From there, call [code]advance()[/code] whenever the player advances the text.
## Alternatively use [code]advance(amount)[/code] to jump forward or back a number
## of lines, or [code]set_position(position)[/code] to jump to a specific line.
## [br][br]
## Implementation notes: [br]
## Should be good enough for now.
class_name DialogueManager
extends Node

signal scene_started(p_left_speaker: DialogueSpeaker, p_right_speaker: DialogueSpeaker)

## This emits two things - a string for the current line of dialogue, and a
## boolean to indicate if it's the last line of dialogue.
signal dialogue_changed(p_line: String, p_done: bool)

## For when dialogue finishes. A couple of different ways of implementing this -
## this one will work for now, I guess.
signal dialogue_done

@export var data: DialogueData = null :
	set(p_data):
		data = p_data
		reset()

@export var position: int = 0 :
	set(p_position):
		position = maxi(0, p_position)
		update_line()

@export var last_line: int = 1 << 31

@export var current_line: String = "" :
	set(p_current_line):
		current_line = p_current_line
		on_dialogue_changed()

func reset():
	if data != null:
		last_line = data.lines.size()
		position = 0
		on_scene_started()

## This is the main way that the game would interact with the dialogue system.
func advance(p_amount: int = 1) -> String:
	if is_last_line():
		dialogue_done.emit()
		return ""
	else:
		position += p_amount
		return current_line

func is_last_line() -> bool:
	return position >= last_line - 1

## Alternatively, use this to jump to a specific line.
func set_position(p_position: int = position) -> String:
	position = p_position
	return current_line

func update_line():
	current_line = data.lines[position] if position < last_line else ""

func on_scene_started():
	if data != null:
		scene_started.emit(data.left_speaker, data.right_speaker)

func on_dialogue_changed():
	if data != null:
		dialogue_changed.emit(current_line, is_last_line())
