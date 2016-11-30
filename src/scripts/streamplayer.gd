extends StreamPlayer

var songs = {}
var current_song
func _ready():
	songs = {
		'hacker in the dark': load("res://res/audio/Hackers in the Dark.ogg"),
		'jazzy forest': load("res://res/audio/Jazzy Forest.ogg"),
		'tango with hades': load("res://res/audio/Tango with Hades.ogg")
	}
	
func play_song(song_name, restart_time = 0, db = 0):
	if current_song != song_name:
		stop()
		set_stream(songs[song_name])
		set_loop_restart_time(restart_time)
		set_autoplay(true)
		set_volume_db(db)
		set_loop(true)
		current_song = song_name
		play()
