# Enhanced Camera2D controller with keyboard/mouse input for strategy games
# Features: Smooth zooming, keyboard panning, click-and-drag movement, and boundary limits
extends Camera2D

# Zoom configuration
@export var zoom_speed: float = 10 # Smoothing factor for zoom interpolation

# Camera boundaries setup
@onready var _game_board_size: int = GlobalGame.get_game_board_size() # Dynamically gets level size
@onready var _pan_min: Vector2 = Vector2(_pan_max_f_x(_game_board_size), _pan_max_f_x(_game_board_size)) # Minimum camera position (calculated)
@export var pan_max: Vector2 = Vector2(512, 512) # Maximum camera position (configurable)

# Zoom limits
@export var zoom_min: float = 0.5 # Closest allowed zoom
@export var zoom_max: float = 2.5 # Farthest allowed zoom

# Internal state variables
var _zoom_target: Vector2 # Target zoom level for smooth interpolation
var _drag_start_mouse_pos: Vector2 = Vector2.ZERO # Mouse position when drag begins
var _drag_start_camera_pos: Vector2 = Vector2.ZERO # Camera position when drag begins
var _is_dragging: bool = false # Drag state flag

# Initial camera setup - centers on game board
func _ready() -> void:
	_zoom_target = zoom
	var camera_pos: int = (16 * _game_board_size) - 16 # Calculates center position
	position = Vector2(camera_pos, camera_pos) # Sets initial camera position

# Main game loop processing all camera movements
func _process(delta: float) -> void:
	_zoom(delta) # Handles zoom input and smoothing
	_simple_pan(delta) # Processes keyboard panning
	_click_and_drag() # Manages mouse drag movement
	_limit_camera() # Enforces camera boundaries

# Handles zoom input and applies smooth zooming
func _zoom(delta: float) -> void:
	# Zoom in/out with keyboard input
	if Input.is_action_just_pressed("camera_zoom_in"):
		_zoom_target *= 1.1 # 10% zoom in
	if Input.is_action_just_pressed("camera_zoom_out"):
		_zoom_target *= 0.9 # 10% zoom out
	
	# Clamp zoom to defined limits
	_zoom_target.x = clamp(_zoom_target.x, zoom_min, zoom_max)
	_zoom_target.y = clamp(_zoom_target.y, zoom_min, zoom_max)
	
	# Smoothly interpolate to target zoom
	zoom = zoom.slerp(_zoom_target, zoom_speed * delta)

# Handles keyboard-based camera panning
func _simple_pan(delta: float) -> void:
	var moveAmount: Vector2 = Vector2.ZERO
	
	# Collect input from all four directions
	if Input.is_action_pressed("camera_move_right"):
		moveAmount.x += 1
	if Input.is_action_pressed("camera_move_left"):
		moveAmount.x -= 1
	if Input.is_action_pressed("camera_move_up"):
		moveAmount.y -= 1
	if Input.is_action_pressed("camera_move_down"):
		moveAmount.y += 1
	
	# Normalize diagonal movement and apply
	moveAmount = moveAmount.normalized()
	position += moveAmount * delta * 1000 * (1 / zoom.x) # Zoom-adjusted speed

# Implements click-and-drag camera movement
func _click_and_drag() -> void:
	# Start drag operation
	if !_is_dragging and Input.is_action_just_pressed("camera_pan"):
		_drag_start_mouse_pos = get_viewport().get_mouse_position()
		_drag_start_camera_pos = position
		_is_dragging = true
	
	# End drag operation
	if _is_dragging and Input.is_action_just_released("camera_pan"):
		_is_dragging = false
	
	# During drag - calculate movement based on mouse displacement
	if _is_dragging:
		var moveVector: Vector2 = get_viewport().get_mouse_position() - _drag_start_mouse_pos
		position = _drag_start_camera_pos - moveVector * 1 / zoom.x # Zoom-adjusted drag

# Enforces camera boundaries to stay within level
func _limit_camera() -> void:
	position.x = clamp(position.x, _pan_min.x, pan_max.x)
	position.y = clamp(position.y, _pan_min.y, pan_max.y)

# Helper function to calculate minimum camera position based on board size
func _pan_max_f_x(game_board_size: int) -> float:
	return (32 * game_board_size) - 544 # number based on level layout
