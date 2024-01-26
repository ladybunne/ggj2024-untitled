extends Node

var audioFormats = ["wav","mp3","ogg"]

var audioStreamPointer2D: int = 0;
var audioStreamPointerMusic: int = 0;
var audioStreamPointer3D: int = 0;
var audioStreamPlayers2D: Array[AudioStreamPlayer2D] = []
var audioStreamPlayers3D: Array[AudioStreamPlayer3D] = []
var musicAudioStreamPlayers: Array[AudioStreamPlayer2D] = []

var sfx_clips = {}
var music_clips = {}


# Called when the node enters the scene tree for the first time.
func _init():
	_get_audio_files("res://Assets/Audio/SFX",sfx_clips)
	_get_audio_files("res://Assets/Audio/Music",music_clips)
	
	# Add new busses for the sfx and music
	_add_bus("Music")
	_add_bus("SFX")
	
	# create audio source
	_create_2DaudioSources(2)
	_create_3DaudioSources(5)
	_create_musicAudioSources(2)
	
	_load_audio_settings()
	
# Add a new bus to the Audio Server
func _add_bus(bus_name : String):
	AudioServer.add_bus(1)
	AudioServer.set_bus_name(1,bus_name)

func play_sfx(clip_name : String):
	if !sfx_clips.has(clip_name):
		print("*** Audio File: %s not found." %clip_name )
		return
	var clip = ResourceLoader.load(sfx_clips[clip_name])
	_play_2d_audio(clip)
	
func _play_2d_audio(clip : AudioStream):
	var player : AudioStreamPlayer2D = audioStreamPlayers2D[audioStreamPointer2D]
	audioStreamPointer2D = (audioStreamPointer2D+1)%audioStreamPlayers2D.size()
	player.stream = clip
	player.play()

func _play_3d_audio(clip : AudioStream, position: Vector3):
	var player : AudioStreamPlayer3D = audioStreamPlayers3D[audioStreamPointer3D]
	audioStreamPointer3D = (audioStreamPointer3D+1)%audioStreamPlayers3D.size()
	player.global_position = position
	player.stream = clip
	player.play()

func play_music(clip_name : String) -> AudioStreamPlayer2D:
	if !music_clips.has(clip_name):
		print("*** Audio File: %s not found." %clip_name )
		return
	var clip = ResourceLoader.load(music_clips[clip_name])
	var asp = _play_music_clip(clip)
	return asp

func _play_music_clip(clip : AudioStream) -> AudioStreamPlayer2D:
	var currentPlayer : AudioStreamPlayer2D = musicAudioStreamPlayers[audioStreamPointerMusic]
	_fade_song_out(currentPlayer)
	
	audioStreamPointerMusic = (audioStreamPointerMusic+1)%musicAudioStreamPlayers.size()
	
	var nextPlayer : AudioStreamPlayer2D = musicAudioStreamPlayers[audioStreamPointerMusic]
	nextPlayer.stream = clip
	_fade_song_in(musicAudioStreamPlayers[audioStreamPointerMusic])

	return nextPlayer

# Coroutine to fade out a song
func _fade_song_out(audio_source : AudioStreamPlayer2D):
	
	if !audio_source.playing:
		return
		
	# Set the timer to whatever the audio_source currently is
	var timer = get_tree().create_timer(1.0)
	
	# Loop until timer gets below or equal to 0
	while timer.time_left > 0:
		# Set the audio_source's volume to be whatever the timer currently is
		audio_source.set_volume_db(linear_to_db(timer.time_left))
		# Wait till the next frame to loop around again.
		await get_tree().process_frame
		
	# Stop the audio_source from playing music
	audio_source.stop()

# Coroutine to fade out a song
func _fade_song_in(audio_source : AudioStreamPlayer2D):
	
	# Set the timer to whatever the audio_source currently is
	var timer = get_tree().create_timer(1.0)
	audio_source.play()

	# Loop until timer gets below or equal to 0
	while timer.time_left > 0:
		# Set the audio_source's volume to be whatever the timer currently is
		audio_source.set_volume_db(linear_to_db(1-timer.time_left))
		# Wait till the next frame to loop around again.
		await get_tree().process_frame

func _create_2DaudioSources(count : int):
	for n in range(0,count):
		var newAudioStreamPlayer : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		add_child(newAudioStreamPlayer)
		audioStreamPlayers2D.append(newAudioStreamPlayer)
		newAudioStreamPlayer.bus = "SFX"

func _create_3DaudioSources(count : int):
	for n in range(0,count):
		var newAudioStreamPlayer : AudioStreamPlayer3D = AudioStreamPlayer3D.new()
		add_child(newAudioStreamPlayer)
		audioStreamPlayers3D.append(newAudioStreamPlayer)
		newAudioStreamPlayer.bus = "SFX"
		
func _create_musicAudioSources(count : int):
	for n in range(0,count):
		var newAudioStreamPlayer : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		add_child(newAudioStreamPlayer)
		musicAudioStreamPlayers.append(newAudioStreamPlayer)
		newAudioStreamPlayer.bus = "Music"
		
# get all audio files in the 'Audio' folder and store them in a dictionary
func _get_audio_files(path,dic):
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				# Recursively call dir_contents for subdirectories
				_get_audio_files(path + "/" + file_name,dic)
			else:
				var extention = file_name.get_extension().to_lower()
				if audioFormats.has(extention):
					dic[file_name.substr(0,file_name.length()-4)] = path + "/" + file_name
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

var sfxVolumeLevel : float
var musicVolumeLevel : float
var masterVolumeLevel : float

func get_master_volume() -> float:
	return masterVolumeLevel
	
func get_sfx_volume() -> float:
	return sfxVolumeLevel
	
func get_music_volume() -> float:
	return musicVolumeLevel

func set_master_volume(value : float):
	masterVolumeLevel = value
	AudioServer.set_bus_volume_db(0,linear_to_db(value))

func set_sfx_volume(value : float):
	sfxVolumeLevel = value
	AudioServer.set_bus_volume_db(1,linear_to_db(value))

func set_music_volume(value : float):
	musicVolumeLevel = value
	AudioServer.set_bus_volume_db(2,linear_to_db(value))

func save_audio_settings():
	var data = {
		"master_volume": masterVolumeLevel,
		"sfx_volume" : sfxVolumeLevel,
		"music_volume" : musicVolumeLevel
	}
	
	var json_string = JSON.stringify(data)
	var save_file = FileAccess.open("user://audio_settings.save", FileAccess.WRITE)
	save_file.store_line(json_string)
	save_file.close()

func _load_audio_settings():
	var save_file : FileAccess = FileAccess.open("user://audio_settings.save", FileAccess.READ)
	
	if save_file == null:
		print("No audio save file, loading default values")
		set_master_volume(1)
		set_sfx_volume(1)
		set_music_volume(1)
		return

	var parse_result = JSON.parse_string(save_file.get_as_text())
	masterVolumeLevel = parse_result["master_volume"]
	sfxVolumeLevel = parse_result["sfx_volume"]
	musicVolumeLevel = parse_result["music_volume"]
