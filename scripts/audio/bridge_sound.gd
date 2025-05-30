extends AudioStreamPlayer

func _ready() -> void:
	# connects to GlobalAudio to receive the signal to perform the function below
	GlobalAudio.connect("play_bridge_sound", self._on_play_bridge_sound)

func _on_play_bridge_sound() -> void:
	if not self.playing:
		self.pitch_scale = randf_range(0.84, 1.16) # random pitch
		self.play()
