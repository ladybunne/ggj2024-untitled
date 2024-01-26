extends Node

var currentScene = null
var sceneDirectory = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().root
	currentScene = root.get_child(root.get_child_count() - 1)
	
	dir_contents("res://")

func load_scene(scene_name):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", scene_name)


func _deferred_goto_scene(scene_name):
	
	if !sceneDirectory.has(scene_name):
		print("** Error ** Can't find scene: " + scene_name)
		return
		
	# It is now safe to remove the current scene.
	currentScene.free()

	# Load the new scene.
	var s = ResourceLoader.load(sceneDirectory[scene_name])

	# Instance the new scene.
	currentScene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(currentScene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = currentScene
	
func dir_contents(path):
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				# Recursively call dir_contents for subdirectories
				dir_contents(path + "/" + file_name)
			else:
				if file_name.get_extension().to_lower() == "tscn":
					sceneDirectory[file_name.substr(0,file_name.length()-5)] = path + "/" + file_name
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
