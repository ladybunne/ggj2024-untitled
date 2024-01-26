extends Node

# Default stored values
var default_save_data = {
	"value1" : 1,
	"value2" : 2,
	"value3" : 3
}

# Current stored values
var save_data

# Init
func _init():
	_load_data()

func set_value1(value : int, doSave = true):
	save_data["value1"] = value
	if doSave:
		_save_data()

func get_value1() -> int:
	return save_data["value1"]

func set_value2(value : int, doSave = true):
	save_data["value2"] = value
	if doSave:
		_save_data()

func get_value2() -> int:
	return save_data["value2"]

func set_value3(value : int, doSave = true):
	save_data["value3"] = value
	if doSave:
		_save_data()

func get_value3() -> int:
	return save_data["value3"]

# Save data from save file
func _save_data():
	var json_string = JSON.stringify(save_data)
	var save_file = FileAccess.open("user://game_data.save", FileAccess.WRITE)
	save_file.store_line(json_string)
	save_file.close()

# Load data from save file
func _load_data():
	var save_file : FileAccess = FileAccess.open("user://game_data.save", FileAccess.READ)

	if save_file == null:
		save_data = default_save_data
		print("No audio save file, loading default values")
		return

	save_data = JSON.parse_string(save_file.get_as_text())

# Reset save data to default values
func clear_data():
	save_data = default_save_data
	_save_data()
