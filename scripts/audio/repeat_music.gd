extends AudioStreamPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not self.playing:
		self.play()
