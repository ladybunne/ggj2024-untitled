extends Node2D

var have_spoken_to_elder = false

func _ready():
	visible = false
	for bug_uncasted in get_tree().get_nodes_in_group("BugGroup"):
		print(bug_uncasted)
		if bug_uncasted is ElderBug:
			bug_uncasted.start_dialogue.connect(func(p_bug: BugEntity): 
				have_spoken_to_elder = true
				print("Show Quest UI")
				visible = true
			)

func _process(delta):
	pass
