class_name StatList
extends Resource

signal stats_changed(p_stats: StatList)

## The list of stats.
# Change the type of this to Stat.
@export var stats: Array[Stat]

func _init():
	call_deferred("on_stats_changed")
	
# Search assumes there are no duplicate names.
# It will return the first match if there are duplicates.
func get_stat(p_name: String) -> Stat:
	var result: Array[Stat] = stats.filter(func(p_stat: Stat): return p_stat.get_identity().name == p_name)
	return result[0] if result.size() else null

## Set the stat's value to a specific number.
func set_stat(p_name: String, p_value: int) -> bool:
	var stat: Stat = get_stat(p_name)
	if stat == null:
		return false
	var old_value = stat.get_value()
	stat.set_value(p_value)
	var outcome = stat.get_value() != old_value
	if outcome:
		on_stats_changed()
	return outcome

## Modify the stat's value by an incoming amount.
## Probably implement this properly at some point. It's fine for now.
func modify_stat(p_name: String, p_value: int) -> bool:
	return set_stat(p_name, p_value + get_stat(p_name).get_value() if get_stat(p_name) != null else 0)

# There's not currently an exposed way to change min/max values.
# It can be done through get_stat().modify_maximum() or similar though.
# This probably warrants fixing at some point.

func on_stats_changed() -> void:
	stats_changed.emit(self)
