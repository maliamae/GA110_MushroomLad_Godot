extends Node

@onready var orb_sound: AudioStreamPlayer = $OrbSound
@onready var music_player: AudioStreamPlayer = $MusicPlayer

var main_menu_music = preload("res://Assets/Audio/dreams.ogg")
var gameplay_music = preload("res://Assets/Audio/kim_lightyear_-_illusion (1).mp3")
var game_over_music = preload("res://Assets/Audio/Kim Lightyear - My Little Castle (Loop) (1).mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CollectibleManager.collectible_added.connect(_on_collectible_sound)
	Transition.scene_changed.connect(_on_scene_changed)
	
	var current_scene = get_tree().current_scene.scene_file_path
	_on_scene_changed(current_scene)

func _on_collectible_sound(type):
	match type:
		CollectibleManager.CollectibleType.ORB:
			orb_sound.play()

func _on_scene_changed(scene_path):
	match scene_path:
		"res://Scenes/main_menu.tscn":
			play_music(main_menu_music)
		"res://Scenes/dungeon_level.tscn":
			play_music(gameplay_music)
		"res://Scenes/game_over.tscn":
			play_music(game_over_music)

func play_music(stream: AudioStream):
	if music_player.stream == stream:
		return
	
	music_player.stop()
	music_player.stream = stream
	music_player.play()
