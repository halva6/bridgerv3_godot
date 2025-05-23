extends AudioStreamPlayer


func _ready() -> void:
	GlobalAudio.connect("play_bridge_sound", self._on_play_bridge_sound)


func _on_play_bridge_sound() -> void:
	if not self.playing:
		self.pitch_scale = randf_range(0.84, 1.16)
		self.play()
