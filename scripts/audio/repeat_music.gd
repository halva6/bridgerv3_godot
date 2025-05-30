extends AudioStreamPlayer

var _is_stopped: bool = false
func _process(delta: float) -> void:
	if not self.playing and not _is_stopped:
		self.play()

func _ready() -> void:
	GlobalAudio.connect("stop_game_music", self._on_stop_game_music)

func _on_stop_game_music() -> void:
	self.stop()
	_is_stopped = true
