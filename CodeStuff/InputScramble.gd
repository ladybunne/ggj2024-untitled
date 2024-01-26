class_name InputScramble extends BugEntity

@export var move_names: Array[String]

func _input(event):
	super._input(event)
	if player_inside != null and event.is_action_pressed("player_interact"):
		# TODO: put this in platformer_character.gd
		for i in range(len(move_names)):
			var temporarySwap = player.get(move_names[i])
			var target = randi_range(0, len(move_names) - 1)
			player.set(move_names[i], player.get(move_names[target]))
			player.set(move_names[target], temporarySwap)
		# TODO: definitely put this in platformer_character.gd
		player._ready()
