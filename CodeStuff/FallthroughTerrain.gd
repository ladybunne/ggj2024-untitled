class_name FallthroughTerrain extends Node

@export var collision_area: CollisionShape2D

@export var solid_color: Color

@export var fallthrough_color: Color

var rectangle: ColorRect

func _ready():
	rectangle = find_child("ColorRect") as ColorRect
	if rectangle != null:
		rectangle.color = fallthrough_color

func toggleCollision():
	collision_area.disabled = !collision_area.disabled
	if rectangle != null:
		if collision_area.disabled:
			rectangle.color = fallthrough_color
		else:
			rectangle.color = solid_color
