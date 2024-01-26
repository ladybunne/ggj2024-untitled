## Same deal as slots.
## [br]
## Make sure you implement StatData in children classes.
class_name Stat
extends Resource

const DEBUG_PRINT_FORMAT: String = "{name}: {value} (min: {minimum}, max: {maximum})"

func set_value(p_value):
	pass

func modify_value(p_value):
	pass

func get_value():
	return -1

func set_minimum(p_value):
	pass

func modify_minimum(p_value):
	pass

func get_minimum():
	return -1

func set_maximum(p_value):
	pass

func modify_maximum(p_value):
	pass

func get_maximum():
	return -1

func get_identity() -> Identity:
	return null

## Use these for displaying values on the UI. They can be different from the actual values!
func get_displayed_value() -> String:
	return str(get_value())

func get_displayed_minimum() -> String:
	return str(get_minimum())

func get_displayed_maximum() -> String:
	return str(get_maximum())

## Use this if you really need to know what a stat is. You probably should know what any given stat
## is, since you made it.
func get_type() -> String:
	return ""

func debug_print(p_name: String,
		p_value: String = get_displayed_value(),
		p_minimum: String = get_displayed_minimum(),
		p_maximum: String = get_displayed_maximum()) -> void:
	print(DEBUG_PRINT_FORMAT.format({
		"name": p_name,
		"value": p_value,
		"minimum": p_minimum,
		"maximum": p_maximum
	}))
