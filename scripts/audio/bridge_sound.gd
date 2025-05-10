extends AudioStreamPlayer


func _ready() -> void:
	GlobalAudio.connect("play_bridge_sound", self._on_play_bridge_sound)


func _on_play_bridge_sound() -> void:
	if not self.playing:
		self.play()
