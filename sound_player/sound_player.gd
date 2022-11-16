extends Node

const HURT_AUDIO_STREAM := preload("res://hurt.wav")
const JUMP_AUDIO_STREAM := preload("res://jump.wav")

@onready var audio_players_container: Node = $AudioPlayers

var audio_players: Array[AudioStreamPlayer]


func _ready() -> void:
	for child in audio_players_container.get_children():
		var audio_player := child as AudioStreamPlayer
		if audio_player != null:
			audio_players.append(audio_player)

func play_sound(audio_stream: AudioStream) -> void:
	for audio_player in audio_players:
		if audio_player.playing:
			continue
		
		audio_player.stream = audio_stream
		audio_player.play()
		break
