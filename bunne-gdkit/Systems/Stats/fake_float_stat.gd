## This does some integer magic to let us [i]pretend[/i] we're dealing with floats.
## Hell yeah for not losing precision.
## 
## Basically just "float in the streets, integer in the sheets".
##
## EDIT: I have been informed this is called a "Fixed".
class_name FakeFloatStat
extends Stat

var bounded: BoundedInt = null

@export var data: FakeFloatStatData = null

func _init(p_bounded: BoundedInt = bounded, p_data: FakeFloatStatData = data):
	bounded = p_bounded
	data = p_data
	call_deferred("ready")

func ready():
	if bounded == null:
		bounded = data.bounded.duplicate()

func set_value(p_value: int):
	bounded.value = p_value

func modify_value(p_value: int):
	bounded.value += p_value

func get_value() -> int:
	return bounded.value

func set_minimum(p_value: int):
	bounded.minimum = p_value

func modify_minimum(p_value: int):
	bounded.minimum += p_value

func get_minimum() -> int:
	return bounded.minimum

func set_maximum(p_value: int):
	bounded.maximum = p_value

func modify_maximum(p_value: int):
	bounded.maximum += p_value

func get_maximum() -> int:
	return bounded.maximum

func get_identity() -> Identity:
	return data.identity

## Use these for displaying values on the UI that are different from the actual values.
func get_displayed_value() -> String:
	return data.convert_to_float_string(get_value())

func get_displayed_minimum() -> String:
	return data.convert_to_float_string(get_minimum())

func get_displayed_maximum() -> String:
	return data.convert_to_float_string(get_maximum())

func get_type() -> String:
	return bounded.get_class()
