extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.play_music("It's a feature! Final 1")
	 # most people turn volume down so lets start with it turned down
	AudioManager.set_music_volume(0.3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
