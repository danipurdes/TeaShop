extends StaticBody3D

var machine_type = "jukebox"
var song_index = 0.0

func _ready():
	startJukebox()

func _process(_delta):
	if Input.is_action_just_pressed("mute"):
		toggleMusicPlaying()

func useItem(_item):
	return toggleMusicPlaying()

func toggleMusicPlaying():
	if $ChillHopBeatsToStudyTo.playing:
		#song_index = $ChillHopBeatsToStudyTo.get_playback_position()
		stopJukebox()
	else:
		startJukebox()
	return true

func startJukebox():
	$ChillHopBeatsToStudyTo.play()
	$ParticleEmitter.emitting = true

func stopJukebox():
	$ChillHopBeatsToStudyTo.stop()
	$ParticleEmitter.emitting = false
