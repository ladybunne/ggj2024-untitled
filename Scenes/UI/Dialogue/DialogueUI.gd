class_name DialogueUI extends CanvasLayer

@export var dialogue_box: DialogueBox
@export var advance_button: Button

func set_bug_data(p_bug_data: BugData):
	dialogue_box.set_bug_data(p_bug_data)

func on_dialogue_changed(_p_line: String, _p_done: bool):
	visible = true

func on_dialogue_done():
	visible = false
