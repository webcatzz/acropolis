extends TileMap


@export var music: AudioStreamMP3
@export var stop_music: bool = false
@export_color_no_alpha var white: Color = Color.WHITE
@export_color_no_alpha var black: Color = Color.BLACK
@export var force_slow: bool = false


func get_scene_name() -> String:
	return scene_file_path.get_file().get_slice(".", 0)
