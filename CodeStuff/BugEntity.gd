class_name BugEntity extends Entity

@export var bug_data: BugData

@export var collision_area: Area2D

signal goal_satisfied

var player_inside: PlatformerCharacter

func _ready():
	if collision_area != null:
		collision_area.body_entered.connect(player_entered)
		collision_area.body_exited.connect(player_exited)

func player_entered(body: Node2D):
	var player := body as PlatformerCharacter
	if player != null:
		player_inside = player
		
func player_exited(body: Node2D):
	var player := body as PlatformerCharacter
	if player != null:
		player_inside = null

func _input(event):
	if player_inside == null:
		return
	if event.is_action_pressed("player_interact"):
		if bug_data == null:
			return
		print("")
		for line in bug_data.dialogue.lines:
			print(line)
