extends Area3D

var song_index = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ping():
	if $ChillHopBeatsToStudyTo.playing:
		song_index = $ChillHopBeatsToStudyTo.get_playback_position()
		$ChillHopBeatsToStudyTo.stop()
	else:
		$ChillHopBeatsToStudyTo.play(song_index)
