# Camera2D extension with touch gesture controls for panning, zooming, and rotating
extends Camera2D

# Configuration variables for gesture sensitivity and limits
@export var zoom_speed: float = 0.075 # Controls how fast zoom gestures respond
@export var pan_speed: float = 1.0 # Controls panning movement speed
@export var rotation_speed: float = 1.0 # Controls rotation sensitivity

@export var zoom_min: float = 0.5 # Minimum allowed zoom level
@export var zoom_max: float = 5 # Maximum allowed zoom level

# Toggle switches for different camera controls
@export var can_pan: bool # Enable/disable panning functionality
@export var can_zoom: bool # Enable/disable zooming functionality
@export var can_rotate: bool # Enable/disable rotation functionality

# Internal variables for tracking touch gestures
var _touch_points: Dictionary = {} # Stores active touch points by index
var _start_distance: float # Initial distance between two touch points
var _start_zoom: Vector2 # Initial zoom level when gesture started
var _start_angle: float # Initial angle between touch points

# Main input handler that routes touch and drag events
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_handle_touch(event) # Handle touch begin/end events
	elif event is InputEventScreenDrag:
		_handle_drag(event) # Handle touch movement events

# Processes touch start/end events to track active fingers
func _handle_touch(event: InputEventScreenTouch) -> void:
	if event.pressed:
		_touch_points[event.index] = event.position # Add new touch point
	else:
		_touch_points.erase(event.index) # Remove released touch point
	
	# When exactly two fingers are down, store initial gesture metrics
	if _touch_points.size() == 2:
		var touch_point_positions: Array = _touch_points.values()
		_start_distance = touch_point_positions[0].distance_to(touch_point_positions[1])
		_start_angle = _get_angle(touch_point_positions[0], touch_point_positions[1])
		_start_zoom = zoom
	elif _touch_points.size() < 2:
		_start_distance = 0 # Reset when not in two-finger gesture

# Processes drag events to implement pan, zoom, and rotate based on finger count
func _handle_drag(event: InputEventScreenDrag) -> void:
	_touch_points[event.index] = event.position # Update touch point position
	
	# Single finger movement - panning
	if _touch_points.size() == 1:
		if can_pan:
			offset -= event.relative.rotated(rotation) * pan_speed
			
	# Two finger movement - zoom and/or rotate
	elif _touch_points.size() == 2:
		var touch_point_positions: Array = _touch_points.values()
		var current_dist: float = touch_point_positions[0].distance_to(touch_point_positions[1])
		var current_angle: float = _get_angle(touch_point_positions[0], touch_point_positions[1])
		var zoom_factor: float = _start_distance / current_dist
		
		if can_zoom:
			zoom = _start_zoom / zoom_factor # Apply zoom based on pinch gesture
		if can_rotate:
			rotation -= (current_angle - _start_angle) * rotation_speed # Apply rotation
			_start_angle = current_angle # Update for continuous rotation
		_limit_zoom(zoom) # Enforce zoom boundaries

# Constrains zoom level to defined minimum and maximum values
func _limit_zoom(new_zoom: Vector2) -> void:
	if new_zoom.x < zoom_min:
		zoom.x = zoom_min
	if new_zoom.y < zoom_min:
		zoom.y = zoom_min
	if new_zoom.x > zoom_max:
		zoom.x = zoom_max
	if new_zoom.y > zoom_max:
		zoom.y = zoom_max

# Helper function to calculate angle between two points in radians
func _get_angle(p1: Vector2, p2: Vector2) -> float:
	var delta: Vector2 = p2 - p1
	return fmod((atan2(delta.y, delta.x) + PI), (2 * PI)) # Returns normalized angle [0, 2π)
