extends Label

@export var base_text: String = "computers turn"
@export var max_dots: int = 3
@export var current_dots: int = 0
@export var time_accum: float = 0.0
@export var interval: float = 0.5 # Sekunden zwischen den Animationen

func _process(delta: float) -> void:
	# a kind of animation that counts a certain number of points to symbolize thinking
	if "computers" in text:
		time_accum += delta
		if time_accum >= interval:
			time_accum = 0
			current_dots = (current_dots + 1) % (max_dots + 1)
			text = base_text + ".".repeat(current_dots)
