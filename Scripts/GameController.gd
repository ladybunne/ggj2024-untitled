extends Control

func _ready():
	#AudioManager.play_music("Game Music")
	pass

func _on_button_pressed():
	FlowController.load_scene("Main Menu")
