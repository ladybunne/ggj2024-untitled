class_name DialogueBox extends PanelContainer

@export_group("Internal")
@export var portrait_rect: TextureRect
@export var title_label: RichTextLabel
@export var dialogue_label: RichTextLabel
@export var dialogue_cursor: TextureRect = null
@export var dialogue_cursor_not_done: Texture2D = null
@export var dialogue_cursor_done: Texture2D = null
@export_group("")

var bug_entity: BugEntity
var is_narrator: bool = false

func set_bug(p_bug_entity: BugEntity):
	bug_entity = p_bug_entity

func update_ui(p_line: String, p_done: bool):
	
	if p_line.begins_with("[sp=-]"):
		is_narrator = true
	else:
		is_narrator = false
	
	if is_narrator:
		portrait_rect.texture = null
		title_label.text = "Narrator"
	
	elif bug_entity != null and bug_entity.bug_data != null and bug_entity.bug_data.identity != null:
		portrait_rect.texture = bug_entity.bug_data.identity.icon
		title_label.text = bug_entity.bug_data.identity.name
	
	dialogue_label.text = p_line
	dialogue_cursor.texture = dialogue_cursor_not_done if not p_done else dialogue_cursor_done
