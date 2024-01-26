## A single instance of a History message. Contains some metadata about what
## the message is and when it arrived.
class_name HistoryMessage
extends Resource

## The contents of the message.
@export var contents: String = ""

## The category of the messsage.
@export var category: String = ""

## The time the message was received.
@export var timestamp: int = 0

## The important learning here - for exported resource types, you absolutely
## MUST have default values for all properties, otherwise things break.
func _init(p_contents: String = contents,
		p_category: String = category,
		p_timestamp: int = int(Time.get_unix_time_from_system())) -> void:
	contents = p_contents
	category = p_category
	timestamp = p_timestamp

func format_timestamp() -> String:
	return Time.get_datetime_string_from_unix_time(timestamp)

func debug_text() -> String:
	return "[{timestamp}] [{category}] {contents}".format({
			"contents": contents,
			"category": category,
			"timestamp": format_timestamp(),
		})
