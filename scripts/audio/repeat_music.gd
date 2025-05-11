extends AudioStreamPlayer

var isStopped: bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not self.playing and not isStopped:
		self.play()

func _ready() -> void:
	GlobalAudio.connect("stop_game_music", self._on_stop_game_music)

func _on_stop_game_music() -> void:
	self.stop()
	isStopped = true
