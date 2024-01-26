## Contrary to convention, EntityData is [i]not[/i] a "data class" that gets
## used for initialisation. It's just a collection of "stuff" an entity can have.
## In this case it's a stat list, a slot list and an inventory.
class_name EntityData
extends IdentityResource

@export var stats: StatList = null

@export var slots: SlotList = null

@export var inventories: Array[Inventory] = []

func _init(p_stats: StatList = stats,
		p_slots: SlotList = slots,
		p_inventories: Array[Inventory] = inventories):
	stats = p_stats
	slots = p_slots
	inventories = p_inventories

## Intended to be used with constants, since Godot doesn't have support for
## typed Dictionaries (lmfao).
func get_inventory(p_index: int = 0) -> Inventory:
	if p_index < 0 or p_index >= inventories.size():
		return null
	return inventories[p_index]
