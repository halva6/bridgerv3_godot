extends Node

@export var do_mulitplayer : bool
@export var inital_player : String

var is_game_over = false
var current_player = "green"

@onready var matrix_logic = $MatrixManager
@onready var matrix_script = $MatrixManager/Matrix

var matrix: Array

func check_game_over(matrix : Array) -> void:
	var green_wins = matrix_logic.check_winner(matrix, 1)
	var red_wins = matrix_logic.check_winner(matrix, 2)
	
	if(green_wins):
		print("Green Wins!")
		is_game_over = true
	if(red_wins):
		print("Red Wins!")
		is_game_over = true

func handle_multiplayer_logic(matrix: Array) -> void:
	if current_player == "green":
		pass
	elif current_player == "red":
		pass

func handle_singleplayer_logic(matrix: Array) -> void:
	pass

func handle_game_logic() -> void:
	if(do_mulitplayer):
		handle_multiplayer_logic(self.matrix)
	else:
		handle_singleplayer_logic(self.matrix)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	matrix = matrix_script.get_matrix()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(! is_game_over):
		handle_game_logic()
		
