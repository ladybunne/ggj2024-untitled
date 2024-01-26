class_name PlatformerCharacter
extends CharacterBody2D

@export_group("Internal")
@export var collision_shape: CollisionShape2D = null
@export var wallslide_shapecast: ShapeCast2D = null
@export_group("")

# Grid properties. Used to express jump parameters more naturally.
# Set to 0 to disable.
@export var grid_width: int = 32
@export var grid_height: int = 32

@export_group("Components")
@export var run_component: RunComponent = null :
	set(p_run_component):
		run_component = p_run_component
		if run_component != null:
			init_run_component()
			
@export var jump_component: JumpComponent = null :
	set(p_jump_component):
		jump_component = p_jump_component
		if jump_component != null:
			init_jump_component()
			
@export var dash_component: DashComponent = null :
	set(p_dash_component):
		dash_component = p_dash_component
		if dash_component != null:
			init_dash_component()
			
## Not implemented yet.
@export var air_action_component: String = ""
@export_group("")

@export_group("Action Names")
@export var move_left_name: String = "player_move_left"
@export var move_right_name: String = "player_move_right"
@export var move_down_name: String = "player_move_down"
@export var jump_name: String = "player_jump"
@export var dash_name: String = "player_dash"
@export_group("")

## Inputs. Caching them locally lets us do cool things like override player
## controls whenever we feel like.
var input_move: Vector2 = Vector2.ZERO
var input_jump: bool = false
var input_dash: bool = false

## A toggle to let you temporarily override player control.
@export var input_enabled: bool = true

## Another one that lets you toggle movement entirely.
@export var movement_enabled: bool = true

var facing_right: bool = true
var coyote_time_timer: Timer = null
var walljump_coyote_time_timer: Timer = null
var dash_timer: Timer = null

enum AnimationState {
	IDLE,
	RUN,
	JUMP,
	FALL,
	GLIDE,
	WALLSLIDE,
	DASH
}

var position_cache: Vector2 = position
var animation_state: AnimationState = AnimationState.IDLE

# The reason we double-initialise these is because I am a terrible programmer.
# Because of initialisation timing issues, the first time they're run, they don't
# actually have any of the referenced nodes under Internal, which breaks my
# shoddy linking code for the jump component getting a reference to the ShapeCast2D.
#
# There's definitely better ways, but future me can find them. Fuck it.
func _ready():
	if run_component != null:
		init_run_component()
	if jump_component != null:
		init_jump_component()
	if dash_component != null:
		init_dash_component()

# Instead of reading inputs directly, we can cache them for greater control.
func _input(event):
	if not input_enabled:
		return
	
	if event.is_echo():
		return
	
	# Movement
	if event.is_action(move_left_name) or event.is_action(move_right_name):
		input_move.x = Input.get_axis(move_left_name, move_right_name)
	
	elif event.is_action(move_down_name):
		input_move.y = event.get_action_strength(move_down_name)
	
	# Jump
	elif event.is_action(jump_name):
		if event.is_pressed():
			input_jump = true
		elif event.is_released():
			input_jump = false
	
	# Dash
	elif event.is_action(dash_name):
		if event.is_pressed():
			input_dash = true
		elif event.is_released():
			input_dash = false

func init_run_component():
	run_component.grid_width = grid_width
	run_component.grid_height = grid_height
	
	run_component.move_left_name = move_left_name
	run_component.move_right_name = move_right_name

func init_jump_component():
	jump_component.grid_width = grid_width
	jump_component.grid_height = grid_height
	
	jump_component.move_left_name = move_left_name
	jump_component.move_right_name = move_right_name
	jump_component.move_down_name = move_down_name
	jump_component.jump_name = jump_name
	
	coyote_time_timer = Timer.new()
	add_child(coyote_time_timer)
	jump_component.coyote_time_timer = coyote_time_timer
	
	walljump_coyote_time_timer = Timer.new()
	add_child(walljump_coyote_time_timer)
	jump_component.walljump_coyote_time_timer = walljump_coyote_time_timer
	
	if wallslide_shapecast != null and collision_shape != null:
		# More magic numbers. Sorry, future me - this will be gone one day.
		var wallslide_shape = RectangleShape2D.new()
		wallslide_shape.size = (collision_shape.shape as RectangleShape2D).size - Vector2(0, 4)
		wallslide_shapecast.shape = wallslide_shape
		
		jump_component.wallslide_shapecast = wallslide_shapecast

func init_dash_component():
	dash_component.grid_width = grid_width
	dash_component.grid_height = grid_height
	
	dash_component.move_left_name = move_left_name
	dash_component.move_right_name = move_right_name
	dash_component.jump_name = jump_name
	dash_component.dash_name = dash_name
	
	dash_timer = Timer.new()
	add_child(dash_timer)
	dash_component.dash_timer = dash_timer

func components() -> Array[PlatformerComponent]:
	return [run_component, jump_component, dash_component]

func reset_velocity():
	for component in components():
		if component != null:
			component.reset_vector()

func reset_input():
	input_move = Vector2.ZERO
	input_jump = false
	input_dash = false

func update_animation_state():
	# Dumb "facing right" thing. Make it better!
	if velocity.x > 0:
		facing_right = true
	if velocity.x < 0:
		facing_right = false
	
	# Preliminary state stuff. Will be improved later.
	if dash_component != null and dash_component.is_dashing():
			animation_state = AnimationState.DASH
	elif jump_component != null and jump_component.is_wallsliding:
			animation_state = AnimationState.WALLSLIDE
	elif jump_component != null and jump_component.is_gliding:
			animation_state = AnimationState.GLIDE
	elif not is_on_floor():
		if position.y <= position_cache.y:
			animation_state = AnimationState.JUMP
		else:
			animation_state = AnimationState.FALL
	else:
		if position.x != position_cache.x:
			animation_state = AnimationState.RUN
		else:
			animation_state = AnimationState.IDLE

# Right now we're running components in a specific order that corresponds
# with their priority. This may or may not become customisable at some point.
func _physics_process(delta):
	velocity = Vector2.ZERO
	
	if movement_enabled:
		if dash_component != null:
			dash_component.facing_right = facing_right
			var dash_vector = dash_component.process(delta, self)
			velocity = dash_vector
			if velocity != Vector2.ZERO:
				run_component.vector.x = run_component.speed() * signi(velocity.x)
				jump_component.jump_velocity = dash_vector.y
		
		# This will need to be changed eventually.
		if jump_component != null and (dash_component == null or not dash_component.is_dashing()):
			velocity.y = jump_component.process(delta, self).y
		else:
			jump_component.process(delta, self)
		
		if run_component != null and (dash_component == null or not dash_component.is_dashing()):
			velocity.x = run_component.process(delta, self).x
		else:
			run_component.process(delta, self)
	
	# Apply gravity if no movement is enabled.
	else:
		if jump_component != null:
			jump_component.apply_gravity(delta, self, false)
			velocity.y = jump_component.jump_velocity
	
	move_and_slide()
	
	update_animation_state()

	position_cache = position
