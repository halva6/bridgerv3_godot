extends AudioStreamPlayer

func _ready() -> void:
	GlobalAudio.connect("play_win_sound", self._on_play_win_sound)

func _on_play_win_sound() -> void:
	if not self.playing:
		self.play()
