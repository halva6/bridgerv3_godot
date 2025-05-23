extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalAudio.connect("play_click_sound", self._on_play_click_sound)


func _on_play_click_sound() -> void:
	if not self.playing:
		self.pitch_scale = randf_range(0.88,1.1)
		self.play()
