## The point of this class is to act as a "child manager" for things like
## slot, stat and inventory UIs. It needs:
##
## - an "entrypoint" at which to create/destroy children
## - a dataset, to determine how many children to maintain
## - a scene reference, to actually spawn children
##
## This should be a one-and-done implementation of child management logic.
class_name UIItemManager
extends Resource

## The "entrypoint" to be used as the location for children.
@export var node_path: NodePath

## The dataset. Since Godot has no generics, this is of limited use.
## Assume it is of the specific type you want to use, and use it that way.
##
## Due to a bug in Godot that crashes the editor if this has a type,
## it's an untyped array for now. No idea why this is happening here.
##
## It should be set programmatically, anyway. I've made it non-export for now.
var dataset: Array :
	set(p_dataset):
		dataset = p_dataset
		scale_children(dataset.size())
		update_children()

## The scene of the child to instantiate.
##
## This [i]must[/i] produce a UIDataItem, otherwise updating will break.
@export var child_source: PackedScene = null

## An internal variable to represent the node loaded by [code]node_path[/code].
var node: Node = null :
	set(p_node):
		node = p_node
		scale_children(dataset.size())
		update_children()

## A signal to emit when children have finished being updated.
signal update_children_finished

func _init(p_node_path: NodePath = node_path, p_child_source: PackedScene = child_source) -> void:
	node_path = p_node_path
	child_source = p_child_source

## A helper function used by UIs to get a proper reference to the child location node.
##
## One day this won't be necessary, hopefully.
func set_node(p_node: Node) -> void:
	node = p_node

func update_children() -> void:
	if node == null or dataset.is_empty():
		return
	var children = node.get_children()
	children.map(func(child: UIDataItem): child.set_data(dataset[children.find(child)]))
	update_children_finished.emit()

func scale_children(amount: int) -> void:
	if node == null:
		return
	var difference = amount - node.get_child_count()
	if difference > 0:
		for i in range(difference):
			node.add_child(child_source.instantiate())
	elif difference < 0:
		for i in range(-difference):
			# This needs to be .free() instead of .queue_free(), otherwise it runs into timing
			# issues.
			node.get_children().front().free()
