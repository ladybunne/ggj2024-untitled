class_name IntStat
extends Stat

## Don't set this directly; let the stat data set it.
## [br]
## Also don't access it directly during runtime; use Stat's functions!
var bounded: BoundedInt = null

@export var data: IntStatData = null

func _init(p_bounded: BoundedInt = bounded, p_data: IntStatData = data):
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

func get_displayed_value() -> String:
	return str(get_value())

func get_displayed_minimum() -> String:
	return str(get_minimum())

func get_displayed_maximum() -> String:
	return str(get_maximum())

func get_type() -> String:
	return bounded.get_class()
