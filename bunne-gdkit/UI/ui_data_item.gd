class_name UIDataItem
extends MarginContainer

## An explicit, accessible-from-elsewhere setter method for whatever
## data variable might exist on a subclass.
##
## This intentionally lacks a specified type, to allow it to work with
## arbitrary types on the subclass. It's the closest to generics we can get.
##
## Subclasses of [code]UIDataItem[/code] can apparently apply their own typing
## to it, and Godot is okay with that! Shit's wild.
func set_data(_p_data) -> void:
	pass
