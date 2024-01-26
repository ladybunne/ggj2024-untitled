## SlotData is a data class to power specific behaviour in Slot instances.
##
## SlotData is intended to be subclassed as needed. Slot subclasses will work
## without specific matching SlotData subclasses (i.e. ItemSlotData for ItemSlot),
## but if you want custom stuff on your slots (you probably do), you need to subclass.
## [br][br]
## Whee!
class_name SlotData
extends IdentityResource

## Forces the slot to only allow its contents to be of the specified category.
## This is above [code]contents[/code] in the variable definition order to force it to load
## before [code]contents[/code], allowing the editor-specified value to be validated correctly.
@export var category_access_list: AccessList = null

## Same deal as require_category, but for the class of the contents.
@export var require_class: String = ""

## Validation function that takes an Identity and checks it against [code]category_access_list[/code].
func validate_category(p_identity: Identity) -> bool:
	if p_identity == null:
		return false
	return category_access_list == null or category_access_list.validate(p_identity.category)

## Maybe this works now??
func validate_class(p_contents) -> bool:
	return require_class.is_empty() or p_contents.is_class(require_class)
