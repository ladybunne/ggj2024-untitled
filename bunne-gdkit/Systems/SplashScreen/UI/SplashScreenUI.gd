extends CanvasLayer

var logo_opacity: float = 0.0

@export var logo: Texture2D

@export var texture_rect: TextureRect

@export var start_delay: Timer
@export var fade_in: Timer
@export var wait_at_full_opacity: Timer
@export var fade_out: Timer
@export var wait_at_no_opacity: Timer

signal done

func _process(_delta):
	if !start_delay.is_stopped():
		logo_opacity = 0
	if !fade_in.is_stopped():
		logo_opacity = 1 - fade_in.time_left / fade_in.wait_time
	elif !wait_at_full_opacity.is_stopped():
		logo_opacity = 1.0
	elif !fade_out.is_stopped():
		logo_opacity = fade_out.time_left / fade_out.wait_time
	else:
		logo_opacity = 0
	
	texture_rect.modulate.a = logo_opacity

func start_delay_end():
	fade_in.start()

func fade_in_end():
	wait_at_full_opacity.start()
	
func wait_at_full_opacity_end():
	fade_out.start()

func fade_out_end():
	wait_at_no_opacity.start()
	
func wait_at_no_opacity_end():
	done.emit()
