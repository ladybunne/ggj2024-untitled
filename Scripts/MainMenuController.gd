extends Control

var controlPanel 

func _ready():
	AudioManager.play_music("Main Menu Music")
	controlPanel = get_node("Options Panel")
	controlPanel.hide()

func _on_button_pressed():
	FlowController.load_scene("Game")
	AudioManager.play_sfx("click1")

func _on_exit_button_pressed():
	AudioManager.play_sfx("click1")
	get_tree().quit()

func _on_options_button_pressed():
	AudioManager.play_sfx("click1")
	controlPanel.show()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			handle_escape_key_pressed()

func handle_escape_key_pressed():
	controlPanel.hide()
