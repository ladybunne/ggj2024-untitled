extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.play_music("its_a_feature_extended_silly")
	 # most people turn volume down so lets start with it turned down
	AudioManager.set_music_volume(0.7)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
