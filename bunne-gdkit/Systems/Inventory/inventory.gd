## An inventory contains a number of item slots.
class_name Inventory
extends Resource

## A signal for when the inventory changes.
signal inventory_changed(p_inventory: Inventory)

## Surprise: an inventory is just... an array! WHOA.
##
## Note to editor initialisations - [i]please[/i], please make sure you set
## slots correctly. I just wasted an hour because I'm a dumbass and forgot
## to.
@export var slots: Array[ItemSlot] = []

@export var default_slot_data: ItemSlotData = null

## A mode enum that controls grow behaviour.
## [br][br]
## (Sidenote: I cannot figure out how to put documentation on enum values.)
enum GrowMode {
	## Do not grow to accommodate new items.
	NONE,
	## Grow to accommodate new items, but do not shrink as items are removed.
	GROW,
	## Grow to accommodate new items, and shrink as items are removed.
	GROW_AND_SHRINK
}

## Whether or not the inventory will grow to accommodate new items.
@export var grow_mode: GrowMode = GrowMode.NONE

## Automatically grow the inventory to a starting size. Set to 0 to disable.
@export_range(0, 1 << 31) var start_slots: int = 0

## The inventory's max size, in slots. Set to 0 to disable.
@export_range(0, 1 << 31) var max_slots: int = 0

## Whether or not to allow multiple stacks of one item.
@export var allow_multiple_stacks: bool = false

# Future features!

## Encumbrance will be a fun one. Games like Skyrim use it to limit how much you can
## carry without consequences. Other games like Zomboid have restrictions on how much
## you can fit in containers.
@export_group("Encumbrance (WIP)")

## WIP.
@export var encumbrance_limit: float = 0.0

## WIP.
enum OverencumberedMode {
	## Ignore encumbrance entirely.
	NONE,
	## Prevent the inventory from ever exceeding the encumbrance limit.
	PREVENT,
	## Allow going over the encumbrance limit... but with a penalty.
	DEBUFF
}

## WIP.
@export var overencumbered_mode: OverencumberedMode = OverencumberedMode.NONE

## WIP.
@export var overencumbered_debuff: Effect = null

## Spatial is my name for Resident Evil 4-style "spatial inventories", where items
## take up some amount of 2d space. This will either require a massive refactor,
## or will need to be broken out into its own class.
##
## Honestly, the more I think about this, it almost certainly needs to be its own class.
## Maybe it could borrow some functionality? Have the two have a shared parent class?
@export_group("Spatial (WIP)")

## WIP.
@export var spatial_enabled: bool = false

## WIP.
@export_range(0, 1 << 31) var spatial_width: int = 0

## WIP.
@export_range(0, 1 << 31) var spatial_height: int = 0

func _init() -> void:
	call_deferred("ready")
	
func ready():
	## Resize to start_slots if the inventory is currently less than.
	if start_slots >= 1 and slots.size() < start_slots:
		# Need to make sure a value of 0 for max_slots disables it clamping start_slots.
		slots.resize(mini(start_slots, max_slots) if max_slots >= 1 else start_slots)
	slots.assign(slots.map(initialise_slot))
	
	print(debug_print())
	on_inventory_change()
#	slots.map(func(slot: SlotData): print(slot.debug_print()))

## Figure out what this function is meant to do.
func initialise_slot(slot: ItemSlot) -> ItemSlot:
	if slot != null:
		return slot
	if default_slot_data != null:
		return ItemSlot.new(default_slot_data)
	return ItemSlot.new()

func grow_slot(p_data: ItemSlotData = null) -> bool:
	## Can't grow if grow is disabled.
	if grow_mode == GrowMode.NONE:
		return false
	
	## Can't grow if grow is enabled and we're at max slots.
	if max_slots >= 1 and slots.size() >= max_slots:
		return false
	
	## Default to incoming slot data, then default slot data, then null if neither exists.
	var data = p_data if p_data != null else default_slot_data if default_slot_data != null else null
	
	var new_slot = initialise_slot(ItemSlot.new(data))
	slots.append(new_slot)
	return true

## Uhh what the fuck do I do with this now??
#func get_slot(p_slot: SlotData) -> SlotData:
#	# If slot argument is null, return null.
#	if p_slot == null:
#		return null
#
#	# If the inventory doesn't have any existing slots, return null.
#	if slots == null or slots.is_empty():
#		return null
#
#	var filter = slots.filter(func(slot: SlotData): return slot == p_slot)
#
#	# If the slot isn't in this inventory, return null.
#	if not filter.size():
#		return null
#
#	var slot = filter.front()
#	return slot

func get_slot(index: int) -> ItemSlot:
	return slots[index]

## Get a slot (if it exists) that:
## - contains the item
## - is not a full stack
func get_slot_for_existing_item(p_item: Item = null) -> ItemSlot:
	if p_item == null:
		return null
	
	var eligible_slots = slots.filter(func(p_slot: ItemSlot): return p_slot.check_slot_contains_partial_stack_of_item(p_item))
	
	return eligible_slots.front() if eligible_slots.size() else null

func check_if_item_in_inventory(p_item: Item) -> bool:
	return slots.any(func(p_slot: ItemSlot): return p_slot.check_slot_contains_item(p_item))

## Attempt to add an item to the inventory. Returns a [code]succeeded[/code] boolean.
func add_item(p_item: Item = null, p_slot: ItemSlot = null) -> bool:
	# If item is null, return false.
	if p_item == null:
		return false
	
	# Check for existing available stacks.
	var existing_stack = get_slot_for_existing_item(p_item)
	if existing_stack != null:
		# Put the item in the stack!
		# TODO Handle overflowing.
		existing_stack.contents.add_quantity(p_item.quantity)
		p_item.data.item_on_pickup()
		on_inventory_change()
		return true
	
	# Now is a good time to prevent multiple stacks!
	if !allow_multiple_stacks and check_if_item_in_inventory(p_item):
		return false
	
	# If p_slot is null (unspecified), get the first available slot.
	# Otherwise, check it with get_slot().
	var slot = p_slot if p_slot != null else get_first_available_slot()
	if slot == null:
		var did_grow = grow_slot()
		if did_grow:
			slot = slots.back()
		else:
			return false
	
	# If slot already has something in it, return false for now.
	# Eventually this will have some better behaviour.
	if slot.contents != null:
		return false
	
	var outcome = slot.set_contents(p_item)
	
	if outcome:
		p_item.data.item_on_pickup()
		on_inventory_change()
	
	return outcome

## Remove an item from a slot. This should usually work.
## TODO Add "shift" functionality to this.
func remove_item(p_slot: ItemSlot) -> bool:
	var slot = p_slot
	
	if slot == null:
		return false
	
	var contents = slot.contents
		
	# If slot is already empty, return false.
	if contents == null:
		return false
	
	var outcome = slot.set_contents(null)
	if outcome:
		contents.data.item_on_discard()
		# Maybe this can be automatic when slot.contents changes? :shrug:
		on_inventory_change()
	
	return outcome

## Move an item from one slot to another.
## Probably allow for different behaviours if there's an existing item there.
##
## SWAP swaps the two.
## SHIFT shifts all other items down a slot.
## DENY prevents a move if there's already something in that slot.
func move_item(p_from: ItemSlot, p_to: ItemSlot) -> bool:
	return false

func check_slot_empty(p_slot: ItemSlot) -> bool:
	return p_slot != null and p_slot.contents == null

func check_slot_full(p_slot: ItemSlot) -> bool:
	return p_slot != null and p_slot.contents != null

func get_empty_slots() -> int:
	return slots.filter(check_slot_empty).size()
	
func get_full_slots() -> int:
	return slots.filter(check_slot_full).size()

func get_first_available_slot() -> ItemSlot:
	var filter = slots.filter(check_slot_empty)
	return filter.front() if filter.size() else null

# This will probably take some doing.
# Need to supply a sort Callable at minimum.
func sort() -> void:
	pass

func on_inventory_change():
	inventory_changed.emit(self)

func debug_print() -> String:
	return "Inventory system loaded. {filled}/{total} slots occupied.".format({
		"filled": get_full_slots(),
		"total": slots.size()
	})
