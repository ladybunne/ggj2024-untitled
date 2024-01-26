class_name SlotList
extends Resource

signal slots_changed(p_slots: SlotList)

## The list of slots.
@export var slots: Array[Slot]

func _init():
	call_deferred("ready")

func ready():
	on_slots_changed()
#	slots.map(func(slot: SlotData): print(slot.debug_print()))
	
# Search assumes there are no duplicate names.
# It will return the first match if there are duplicates.
func get_slot(p_name: String) -> Slot:
	var filter: Array[Slot] = slots.filter(func(slot: Slot): return slot.get_identity().name == p_name)
	if filter.size():
		return filter.front()
	else:
		return null

func set_slot(p_name: String, p_contents) -> bool:
	var slot: Slot = get_slot(p_name)
	if slot == null:
		return false
	var old_contents = slot.get_contents()
	slot.set_contents(p_contents)
	var outcome = slot.get_contents() != old_contents
	if outcome:
		on_slots_changed()
	return outcome

func on_slots_changed() -> void:
	slots_changed.emit(self)
