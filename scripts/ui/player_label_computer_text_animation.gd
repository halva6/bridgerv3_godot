extends Label

var base_text = "computers turn"
var max_dots = 3
var current_dots = 0
var time_accum = 0.0
var interval = 0.5 # Sekunden zwischen den Animationen

func _process(delta):
	if "computers" in text:
		time_accum += delta
		if time_accum >= interval:
			time_accum = 0
			current_dots = (current_dots + 1) % (max_dots + 1)
			text = base_text + ".".repeat(current_dots)
