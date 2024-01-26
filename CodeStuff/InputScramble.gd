class_name InputScramble extends BugEntity

@export var move_names: Array[String]

func _input(event):
	super._input(event)
	if player_inside != null and event.is_action_pressed("player_interact"):
		# Reaching inside player and setting/getting properties is very naughty
		# but we don't want to refactor/modify platformer_character so this is
		# the only way to shuffle the input keys
		for i in range(len(move_names)):
			var temporarySwap = player.get(move_names[i])
			var target = randi_range(0, len(move_names) - 1)
			player.set(move_names[i], player.get(move_names[target]))
			player.set(move_names[target], temporarySwap)
		# Need to call init_run_component()/init_jump_component() to
		# reinitialise move_left_name/move_right_name in the run/jump
		# components. An extra naughty way to do this without refactoring
		# platformer_character is to just call _ready() again :-)
		player._ready()
