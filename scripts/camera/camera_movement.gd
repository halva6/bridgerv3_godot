extends Camera2D

@export var zoomSpeed : float = 10

@onready var game_board_size: int = GlobalGame.get_game_board_size()
@onready var pan_min : Vector2 = Vector2(pan_max_f_x(game_board_size), pan_max_f_x(game_board_size))
@export var pan_max : Vector2 = Vector2(512,512)

@export var zoom_min : float = 0.5
@export var zoom_max : float = 2.5

var zoomTarget : Vector2

var dragStartMousePos: Vector2 = Vector2.ZERO
var dragStartCameraPos: Vector2 = Vector2.ZERO
var isDragging : bool = false

func _ready() -> void:
	zoomTarget = zoom
	var camera_pos: int = (16 * game_board_size) - 16
	position = Vector2(camera_pos, camera_pos)

func _process(delta: float) -> void:
	Zoom(delta)
	SimplePan(delta)
	ClickAndDrag()
	limit_camera()

func Zoom(delta: float) -> void:
	if Input.is_action_just_pressed("camera_zoom_in"):
		zoomTarget *= 1.1
	if Input.is_action_just_pressed("camera_zoom_out"):
		zoomTarget *= 0.9
	# Begrenze Zoom
	zoomTarget.x = clamp(zoomTarget.x, zoom_min, zoom_max)
	zoomTarget.y = clamp(zoomTarget.y, zoom_min, zoom_max)
	zoom = zoom.slerp(zoomTarget, zoomSpeed * delta)

func SimplePan(delta: float) -> void:
	var moveAmount: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("camera_move_right"):
		moveAmount.x += 1
	if Input.is_action_pressed("camera_move_left"):
		moveAmount.x -= 1
	if Input.is_action_pressed("camera_move_up"):
		moveAmount.y -= 1
	if Input.is_action_pressed("camera_move_down"):
		moveAmount.y += 1
	moveAmount = moveAmount.normalized()
	position += moveAmount * delta * 1000 * (1/zoom.x)

func ClickAndDrag() -> void:
	if !isDragging and Input.is_action_just_pressed("camera_pan"):
		dragStartMousePos = get_viewport().get_mouse_position()
		dragStartCameraPos = position
		isDragging = true
	if isDragging and Input.is_action_just_released("camera_pan"):
		isDragging = false
	if isDragging:
		var moveVector: Vector2 = get_viewport().get_mouse_position() - dragStartMousePos
		position = dragStartCameraPos - moveVector * 1/zoom.x

func limit_camera():
	# Begrenze die Kameraposition auf pan_min und pan_max
	position.x = clamp(position.x, pan_min.x, pan_max.x)
	position.y = clamp(position.y, pan_min.y, pan_max.y)
	
func pan_max_f_x(game_board_size) -> float:
	return (32 * game_board_size) - 544
	
