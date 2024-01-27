class_name InputScramble extends BugEntity

@export var move_names: Array[String]

var scrambled: bool
var original_move_names: Array[String]

func _input(event):
	super._input(event)
	if platformer_inside != null and event.is_action_pressed("player_interact"):
		if !scrambled:
			# Save existing inputs
			original_move_names = []
			for i in range(len(move_names)):
				original_move_names.append(platformer_character.get(move_names[i]))
			# Reaching inside player and setting/getting properties is very naughty
			# but we don't want to refactor/modify platformer_character so this is
			# the only way to shuffle the input keys
			for i in range(len(move_names)):
				var temporarySwap = platformer_character.get(move_names[i])
				var target = randi_range(0, len(move_names) - 1)
				platformer_character.set(move_names[i], player.get(move_names[target]))
				platformer_character.set(move_names[target], temporarySwap)
			# Need to call init_run_component()/init_jump_component() to
			# reinitialise move_left_name/move_right_name in the run/jump
			# components. An extra naughty way to do this without refactoring
			# platformer_character is to just call _ready() again :-)
			platformer_character._ready()
		else:
			# Unscramble by restoring original names
			for i in range(len(move_names)):
				platformer_character.set(move_names[i], original_move_names[i])
			platformer_character._ready()
		scrambled = !scrambled
