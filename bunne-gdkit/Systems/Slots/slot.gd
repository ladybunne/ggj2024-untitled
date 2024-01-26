## Slots are basically just glorified containers that can be configured nicely.
## They're designed to be used in groups, to represent things like inventories,
## equipment slots, or even things like party members or equipped skills.
##
## The concept is [i]very[/i] abstract, intentionally, as the pattern is widely
## applicable. As such, this implementation is aimed at allowing subclassing
## to provide most of the specific implementation-specific behaviours.
## [br][br]
## Slots have two things - a [b]contents[/b] field, representing what's in the
## slot, and a [b]data[/b] field, representing slot configuration data. This
## will almost always include category allow-listing to restrict a slot's
## contents to a specific kind of [i]thing[/i], and might include things like
## stack sizes for item slots or restrictions around party member roles (e.g.
## a slot for "healers", a slot for "tanks", etc.).
## [br][br]
## Both of these fields MUST be implemented by a subclass. Their type may be
## declared by the subclass. Each of the functions in this class are like
## abstract functions - conveniently, the types of these functions can be
## declared by subclasses.
## [br][br]
## I'm moderately sure that [code]data[/code] must be above [code]contents[/code]
## in subclasses (like, PHYSICALLY above), otherwise the load order will interfere
## with validation. Maybe. I'm not sure. That was how it was before all this refactoring.
## [br][br]
## The contents field can have [code]set_contents[/code] and
## [code]get_contents()[/code] assigned as setter and getter, respectively.
class_name Slot
extends Resource

## Setter function for [code]contents[/code]. Returns true if it was changed.
func set_contents(p_contents) -> bool:
	return true

## Getter function for [code]contents[/code].
func get_contents():
	pass

## Validator to be used before assigning to [code]contents[/code].
func validate_contents(p_contents) -> bool:
	return true

func get_identity() -> Identity:
	return null
