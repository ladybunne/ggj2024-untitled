extends Node2D

var have_spoken_to_elder = false

@export var quest_item_1: Sprite2D
@export var quest_item_2: Sprite2D
@export var quest_item_3: Sprite2D

func _ready():
	visible = true
	for bug_uncasted in get_tree().get_nodes_in_group("BugGroup"):
		if bug_uncasted is ElderBug:
			bug_uncasted.start_dialogue.connect(func(p_bug_data: BugData): 
				spoke_to_elder_bug()
			)
		if bug_uncasted is FallThroughWorldBug:
			bug_uncasted.start_dialogue.connect(func(p_bug_data: BugData): 
				spoke_to_fall_bug()
			)
		if bug_uncasted is NoCollisionBug:
			bug_uncasted.goal_satisfied.connect(func(p_bug: BugEntity): 
				brought_romantics_together()
			)

func spoke_to_elder_bug():
	have_spoken_to_elder = true
	print("Show Quest UI")
	visible = true

func spoke_to_fall_bug():
	print("Check first quest item")
	visible = true # just in case they didnt talk to elder bug
	quest_item_1.modulate = Color(1, 1, 1, 1)

func brought_romantics_together():
	print("Check second quest item")
	quest_item_2.modulate = Color(1, 1, 1, 1)
