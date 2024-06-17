extends StaticBody3D

var machine_type = "jukebox"
var song_index = 0.0

func _ready():
	$ChillHopBeatsToStudyTo.finished.connect(startJukebox)
	startJukebox()

func _process(_delta):
	if Input.is_action_just_pressed("mute"):
		toggleMusicPlaying()

func useItem(_item):
	return toggleMusicPlaying()

func toggleMusicPlaying():
	if $ChillHopBeatsToStudyTo.playing:
		song_index = $ChillHopBeatsToStudyTo.get_playback_position()
		stopJukebox()
	else:
		resumeJukebox(song_index)
	return true

func startJukebox():
	song_index = 0
	$ChillHopBeatsToStudyTo.play()
	$ParticleEmitter.emitting = true

func resumeJukebox(song_id):
	$ChillHopBeatsToStudyTo.play(song_id)
	$ParticleEmitter.emitting = true

func stopJukebox():
	$ChillHopBeatsToStudyTo.stop()
	$ParticleEmitter.emitting = false
