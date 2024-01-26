class_name BoundedInt
extends Resource

## The current value of the bounded int. Will always be constrained between min and max, inclusive.
@export var value: int = 0 :
	set(p_value):
		value = clampi(p_value, minimum, maximum)

## The minimum a bounded int can be set to.
@export var minimum: int = -(1 << 31) :
	set(p_minimum):
		minimum = mini(p_minimum, maximum)
		if minimum > value:
			value = value;

## The maximum a bounded int can be set to.
@export var maximum: int = 1 << 31 :
	set(p_maximum):
		maximum = maxi(p_maximum, minimum)
		if maximum < value:
			value = value;

func _init(p_value: int = value, p_minimum: int = minimum, p_maximum: int = maximum):
	value = p_value
	minimum = p_minimum
	maximum = p_maximum
