## History is a collection of HistoryMessages. It's bundled up for the purposes
## of saving and loading, mostly.
class_name History
extends Resource

## The array of messages. This [i]should[/i] stay sorted in chronological order,
## since messages get appended at the end.
##
## It should be okay to be accessed from things like UIs.
@export var messages: Array[HistoryMessage] = []

## A signal to get sent whenever messages is modified.
signal new_message_added

## Add a message! This gets called by HistoryManager, which is the intended
## way to interact with the system.
func add_message(p_message: String, p_category: String) -> void:
	var new_message = HistoryMessage.new(p_message, p_category)
	messages.append(new_message)
	print(new_message.debug_text())
	on_new_message_added()

## Gets the n most recent messages.
## Not sure this should be a String, but whatever.
func get_last_messages(p_quantity: int = 10, p_verbose: bool = false) -> String:
	var subset = messages.slice(-maxi(1, p_quantity))
	if not p_verbose:
		return convert_messages_minimal(subset)
	else:
		return convert_messages_verbose(subset)

func get_all_messages(p_verbose: bool = false) -> String:
	if not p_verbose:
		return convert_messages_minimal(messages)
	else:
		return convert_messages_verbose(messages)

func convert_messages_minimal(p_messages: Array[HistoryMessage]) -> String:
	return convert_messages_to_string(p_messages, func(message: HistoryMessage): return message.contents)

func convert_messages_verbose(p_messages: Array[HistoryMessage]) -> String:
	return convert_messages_to_string(p_messages, func(message: HistoryMessage): return message.debug_text())

func convert_messages_to_string(p_messages: Array[HistoryMessage], p_function: Callable) -> String:
	return p_messages.reduce(func(acc: String, message: HistoryMessage): return acc + p_function.call(message) + "\n", "")

## Testing.
func debug_print() -> void:
	print(get_all_messages())

func on_new_message_added():
	new_message_added.emit()
