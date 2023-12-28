extends Area3D

var song_index = 0.0

func ping():
	if $ChillHopBeatsToStudyTo.playing:
		song_index = $ChillHopBeatsToStudyTo.get_playback_position()
		$ChillHopBeatsToStudyTo.stop()
	else:
		$ChillHopBeatsToStudyTo.play(song_index)
