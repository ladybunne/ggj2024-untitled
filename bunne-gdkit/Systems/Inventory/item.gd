## Essentially we shouldn't be using ItemData as a representation of a specific
## [i]instance[/i] of an item. That's bad.
class_name Item
extends Resource

@export var data: ItemData = null

## The quantity of the item represented by this item data. Think a stack of arrows.
## 
## This might be better as a BoundedInt, but there's fucky stuff with ItemData
## potentially being null.
@export_range(1, 1 << 31) var quantity: int = 1 :
	set(p_quantity):
		if data != null:
			quantity = clampi(p_quantity, 1, data.stack_size if data.stack_size > 0 else MAX_STACK_SIZE)
		else:
			quantity = p_quantity

const MAX_STACK_SIZE = 1 << 31

func _init(p_data: ItemData = data, p_quantity: int = quantity):
	data = p_data
	quantity = p_quantity

func get_identity() -> Identity:
	return data.identity

## Combines two stacks of identical items.
##
## Takes an item, [code]p_item[/code], which is assumed to be the same kind of
## item as this item. Combination will fail if it isn't, obviously.
##
## [code]p_stack_size[/code] is typically provided by the parent slot this item
## is in. It will be overrided by this item's [code]stack_size[/code].
func combine_stack(p_item: Item, p_stack_size: int = data.stack_size) -> Item:
	# Can't combine if they're not the same item.
	if p_item.get_identity() != get_identity():
		return p_item
	
	# Since I'm a sleepy bitch, I need to spell this out - this either takes the
	# ITEM's stack size if it's present, otherwise it takes the SLOT's.
	var stack_size = data.stack_size if data.stack_size > 0 else p_stack_size
	
	# Can't combine if either item is full.
	if quantity >= stack_size or p_item.quantity >= stack_size:
		return p_item
	
	var amount_to_move = mini(stack_size - quantity, p_item.quantity)
	quantity += amount_to_move
	p_item.quantity -= amount_to_move
	
	return p_item if p_item.quantity > 0 else null

## Splits one item into two stacks, leaving the remainder on this item.
##
## Returns null if this item's quantity <= 1.
func split_stack() -> Item:
	var quantity_to_take = quantity / 2
	if quantity_to_take <= 0:
		return null
	
	var new_stack = self.duplicate()
	quantity -= quantity_to_take
	new_stack.quantity = quantity_to_take
	
	return new_stack

## Make this adhere to limits... later.
## EDIT: WHY THE FUCK DIDN'T I DO THIS AT THE TIME??
## 
## Given that this works basically the same way as combine_stack, they should
## be merged, or at least have the same backing logic.
func add_quantity(p_quantity: int = 1, p_stack_size: int = data.stack_size) -> Item:
	var new_quantity = quantity + p_quantity
	
	# Same as combine_stack.
	var stack_size = data.stack_size if data.stack_size > 0 else p_stack_size
	
	if new_quantity > stack_size:
		quantity = stack_size
		var remainder: Item = self.duplicate()
		remainder.quantity = new_quantity - quantity
		return remainder
	
	else:
		quantity += p_quantity
		return null
