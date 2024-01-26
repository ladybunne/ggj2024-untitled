class_name DashComponent
extends PlatformerComponent

# Some notes:

# - Need to add coyote time for... ground dashes, walldashes, etc.
# - Have an option for walldashes. They should be performable without any airdashes.
# - Have an "infinite dash" option that overrides dash duration and uses.
# - Test this shit.

@export var dash_speed: int = 24

## Need to add an option for this to be indefinite if it's < 0.
@export var duration: float = 0.3

## This gets provided by the PlatformerCharacter.
var dash_timer: Timer = null : 
	set(p_dash_timer):
		dash_timer = p_dash_timer
		if dash_timer != null:
			dash_timer.wait_time = duration
			
			# This is terrible, but it's good enough for now. 
			if air_dashes < 0:
				dash_timer.wait_time = 300
			
			dash_timer.one_shot = true
			dash_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
			dash_timer.timeout.connect(stop_dash)

## Set to -1 to enable infinite airdashes.
@export var air_dashes: int = 0
var current_air_dashes: int = 0

## Whether the character stops dashing if they hit a wall.
## Not implemented yet.
@export var stop_on_walls: bool = true

## Whether you can hit the dash button while a dash is active, and have it restart the dash.
@export var redash_while_active: bool = false

## Whether the dash ends if you let go of the action button.
@export var end_dash_when_action_released: bool = false

## Whether doing a jump input cancels an active dash.
@export var jump_cancel_dash: bool = true


@export_group("Not Implemented Yet")

## Whether air dashes get refreshed by touching a wall.
## Not implemented yet.
@export var refresh_air_dashes_on_wall_touch: bool = false

@export_group("")


# Input names. Set by the PlatformerCharacter this exists on.
var move_left_name: String = ""
var move_right_name: String = ""
var jump_name: String = ""
var dash_name: String = ""

var facing_right: bool = true

func is_dashing() -> bool:
	return not dash_timer.is_stopped()

func start_dash(p_character: PlatformerCharacter) -> void:
	vector.x = dash_speed * grid_width
	vector.y = 0 
	
	var direction = p_character.input_move.x
	
	# This is terrible, but oh well.
	# If the jump component tells us we're against a wall, dash off the wall.
	if p_character.jump_component.is_on_wall_cache:
		vector.x *= p_character.get_wall_normal().x
	
	# If holding a direction, dash in that direction.
	elif direction:
		vector.x *= sign(direction)
		
	# Otherwise dash in the direction we're facing.
	elif not facing_right:
		vector.x *= -1
		
	if dash_timer != null:
		dash_timer.start()

func stop_dash() -> void:
#	print("stop dash")
	vector = Vector2.ZERO
	
	if dash_timer != null:
		dash_timer.stop()

func update_vector(p_delta: float, p_character: PlatformerCharacter) -> void:
	# Refresh air dashes.
	if p_character.is_on_floor():
		current_air_dashes = air_dashes
		
	# Start a dash.
	if p_character.input_dash and Input.is_action_just_pressed(dash_name):
		if redash_while_active or not is_dashing():
			if p_character.is_on_floor() or current_air_dashes != 0: 
				start_dash(p_character)
				if not p_character.is_on_floor():
					current_air_dashes -= 1
	
	# Stop a dash, possibly.
	elif not p_character.input_dash and Input.is_action_just_released(dash_name) and \
			end_dash_when_action_released:
		stop_dash()
	
	# If we've hit a wall, stop dashing.
	elif stop_on_walls and is_dashing() and p_character.is_on_wall():
		stop_dash()
	
	# Allow jump-cancelling of dashes.
	if jump_cancel_dash and is_dashing() and \
			 p_character.input_jump and Input.is_action_just_pressed(jump_name):
		stop_dash()
	
	# Add a toggle for this later, but this is a Dustforce-esque dash that locks your y-velocity to 0
	# during the dash.
	if is_dashing():
		p_character.jump_component.jump_velocity = 0

func reset_vector() -> void:
	stop_dash()
