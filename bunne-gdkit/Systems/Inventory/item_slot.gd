## Subclass of Slot to contain items!
class_name ItemSlot
extends Slot

@export var data: ItemSlotData

@export var contents: Item = null : set = set_contents, get = get_contents

func _init(p_data: ItemSlotData = data, p_contents: Item = contents):
	data = p_data
	set_contents(p_contents)

func set_contents(p_contents: Item) -> bool:
	var old_contents = contents
	if validate_contents(p_contents):
		contents = p_contents
	return contents != old_contents

func get_contents() -> Item:
	return contents

func validate_contents(p_contents: Item) -> bool:
	return p_contents == null or data == null or \
		(data.validate_category(p_contents.data.identity) and \
		data.validate_class(p_contents))

func get_identity() -> Identity:
	return data.identity

func max_stack_size() -> int:
	var data_stack_size = data.stack_size if data != null else 0
	var contents_stack_size = contents.data.stack_size if contents != null else 0
	
	return contents_stack_size if contents_stack_size > 0 else data_stack_size

func check_slot_contains_item(p_item: Item) -> bool:
	## If the provided item or contents is null, return false.
	if p_item == null or contents == null:
		return false
	
	## If the two items don't match, return false.
	if contents.data != p_item.data:
		return false
	
	## Otherwise, it's a match!
	return true

## Check if this is a slot containing a non-full stack of an item.
func check_slot_contains_partial_stack_of_item(p_item: Item) -> bool:
	## The same as above...
	if !check_slot_contains_item(p_item):
		return false
	
	# But with one extra check!
	
	## If this item's quantity is at (or above??) the max stack size for this
	## item type, return false.
	if max_stack_size() != 0 and contents.quantity >= max_stack_size():
		return false
	
	return true
