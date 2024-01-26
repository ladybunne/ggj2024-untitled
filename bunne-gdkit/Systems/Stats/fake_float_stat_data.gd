## When setting bounded values for this, keep in mind that they will be divided
## by [code]10 ^ digits[/code] later on for display.
## [br][br]
## This means you'll need to work with this data as if it is quite a bit larger
## (e.g. with a [code]digits[/code] of 2, you'll need to use 732 instead of 7.32).
class_name FakeFloatStatData
extends IdentityResource

@export var bounded: BoundedInt = null
@export var digits: int = 1

const FLOAT_FORMAT_STRING: String = "{whole}.{decimal}"

func _init(p_bounded: BoundedInt = bounded, p_digits: int = digits):
	bounded = p_bounded
	digits = p_digits

func convert_to_float_string(p_number: int) -> String:
	return FLOAT_FORMAT_STRING.format({
		"whole": p_number / (10 ** digits),
		"decimal": p_number % (10 ** digits)
	})
