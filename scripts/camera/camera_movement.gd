extends Camera2D

@export var zoomSpeed : float = 10;

var zoomTarget :Vector2

var dragStartMousePos: Vector2 = Vector2.ZERO
var dragStartCameraPos: Vector2 = Vector2.ZERO
var isDragging : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zoomTarget = zoom

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Zoom(delta)
	SimplePan(delta)
	ClickAndDrag()
	
func Zoom(delta: float) -> void:
	if Input.is_action_just_pressed("camera_zoom_in"):
		zoomTarget *= 1.1
		
	if Input.is_action_just_pressed("camera_zoom_out"):
		zoomTarget *= 0.9
		
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
		
	
	
