## A singleton / autoloading class that provides access to the History system
## from anywhere.
extends Node

## The History object.
var history: History

## Where the history will be stored. This will need to be configurable, probably,
## to support things like Profiles.
const HISTORY_PATH: String = "user://history.tres"

func _init():
	# Load history if it exists.
	if ResourceLoader.exists(HISTORY_PATH):
		var loaded_history = load(HISTORY_PATH)
		if loaded_history is History:
			history = loaded_history
	# Otherwise, create a new instance.
	else:
		history = History.new()
	
	# Testing.
	history.new_message_added.connect(new_message_added)
	add_message("This is a message from Ladybunne.", "cool")

## Use this to add messages to the history system.
func add_message(p_message: String, p_category: String) -> void:
	history.add_message(p_message, p_category)

## Hook into this to save history whenever it is modified.
## This saving may work better when it's tied in with Profiles eventually.
func new_message_added():
	# Commenting this out for testing.
	# ResourceSaver.save(history, HISTORY_PATH)
	pass
