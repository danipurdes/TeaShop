extends StaticBody3D

var machine_type = "jukebox"
var song_index = 0.0
var state:String = "on"

signal state_changed(new_state)

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
	set_state("on")

func resumeJukebox(song_id):
	$ChillHopBeatsToStudyTo.play(song_id)
	$ParticleEmitter.emitting = true
	set_state("on")

func stopJukebox():
	$ChillHopBeatsToStudyTo.stop()
	$ParticleEmitter.emitting = false
	set_state("off")

func set_state(new_state):
	if new_state == state:
		return
	state = new_state
	state_changed.emit(new_state)