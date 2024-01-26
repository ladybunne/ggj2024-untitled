## A convenient bundling of several other systems to represent a being.
class_name Entity
extends Node

@export var data: EntityData = null

func _init(p_data: EntityData = data):
	data = p_data

## Wrapper for EntityData's version.
func get_inventory(p_index: int = 0) -> Inventory:
	return data.get_inventory(p_index)
