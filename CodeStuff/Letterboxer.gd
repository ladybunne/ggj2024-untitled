class_name Letterboxer extends Node

@export var top_bar: ColorRect
@export var bottom_bar: ColorRect

# Size of bars in pixels
@export var size: int = 120
# How long the letterboxing animation takes
@export var time_taken: float = 3.0

var is_letterboxing: bool = false
var current_size: float = 0.0
var max_y: int

func _ready():
	is_letterboxing = false
	max_y = get_viewport().size.y

func _process(delta):
	var changing: bool = false
	if is_letterboxing and current_size < size:
		# Transitioning from not letterboxing to letterboxing
		current_size += (delta / time_taken) * size
		current_size = min(current_size, size)
		changing = true
	if !is_letterboxing and current_size > 0:
		# Transitioning from letterboxing to not letterboxing
		current_size -= (delta / time_taken) * size
		current_size = max(current_size, 0)
		changing = true
	if changing:
		top_bar.size.y = current_size as int
		bottom_bar.size.y = current_size as int
		bottom_bar.position.y = max_y - current_size as int

func toggle():
	is_letterboxing = !is_letterboxing
