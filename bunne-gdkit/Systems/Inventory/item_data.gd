## ItemData represents items. Obviously.
class_name ItemData
extends IdentityResource

## The item's personal stack size limit. Overrides a slot's stack limit. Ignored if zero.
@export var stack_size: int = 0

## Whether the item is consumed on use.
##
## This is true by default, because most items that can be used will probably be consumable,
## and it's an irrelevant property for items that [i]can't[/i] be used.
##
## On second thought, no.
@export var consumable: bool = false


@export var on_pickup: Effect = null

@export var on_use: Effect = null

@export var on_discard: Effect = null

signal item_consumed

func _init(p_stack_size: int = stack_size,
	p_on_pickup: Effect = on_pickup) -> void:
	stack_size = p_stack_size
	on_pickup = p_on_pickup

# Unique

## Check this to add things like menu options to use items.
func is_usable() -> bool:
	return on_use != null

# Things that happen when you...
func item_on_pickup():
	if on_pickup != null:
		on_pickup.effect()

func item_on_use():
	if on_use != null:
		on_use.effect()
	
	if consumable:
		item_consumed.emit()

func item_on_discard():
	if on_discard != null:
		on_discard.effect()
