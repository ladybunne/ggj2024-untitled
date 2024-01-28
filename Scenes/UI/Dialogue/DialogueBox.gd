class_name DialogueBox extends PanelContainer

@export_group("Internal")
@export var portrait_rect: TextureRect
@export var title_label: RichTextLabel
@export var dialogue_label: RichTextLabel
@export var dialogue_cursor: TextureRect = null
@export var dialogue_cursor_not_done: Texture2D = null
@export var dialogue_cursor_done: Texture2D = null
@export var player_portrait: Texture2D = null
@export_group("")

var bug_data: BugData
var is_narrator: bool = false
var is_player: bool = false

func set_bug_data(p_bug_data: BugData):
	bug_data = p_bug_data

func update_ui(p_line: String, p_done: bool):
	
	if p_line.begins_with("[sp=-]"):
		is_narrator = true
		is_player = false
		p_line = p_line.substr(6)
	elif p_line.begins_with("[sp=p]"):
		is_narrator = false
		is_player = true
		p_line = p_line.substr(6)
	elif p_line.begins_with("[sp=b]"):
		is_narrator = false
		is_player = false
		p_line = p_line.substr(6)
	
	if is_narrator:
		portrait_rect.texture = null
		title_label.text = "Narrator"
	elif is_player:
		portrait_rect.texture = player_portrait
		title_label.text = "Bee Friend!"
	elif bug_data != null and bug_data != null and bug_data.identity != null:
		portrait_rect.texture = bug_data.identity.icon
		title_label.text = bug_data.identity.name
	
	dialogue_label.text = p_line
	dialogue_cursor.texture = dialogue_cursor_not_done if not p_done else dialogue_cursor_done
