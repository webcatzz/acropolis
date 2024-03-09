extends Node


var data: Resource = load("res://data/player.tres")

@onready var player: Node2D = get_node("/root/Shell/Player")
@onready var world: Node2D = get_node("/root/Shell/World")


func portal(scene: String, portal: Area2D):
	var old_scene: String = world.get_scene_name()
	var position: Vector2 = player.position - portal.position
	var was_slowed: bool = world.force_slow
	
	world.queue_free()
	await get_tree().process_frame
	world = load("res://scenes/" + scene + ".tscn").instantiate()
	world.name = "World"
	get_node("/root/Shell").add_child(world)
	get_node("/root/Shell").move_child(world, 0)
	
	world.get_node(old_scene).ticked = true
	player.position = position + world.get_node(old_scene).position
	if world.force_slow and player.spd_mod == 1.0:
		player.spd_mod = 0.5
		var event = InputEventAction.new()
		event.action = "shift"
		event.pressed = false
		Input.parse_input_event(event)
	elif was_slowed and !Input.is_action_pressed("shift"):
		var event = InputEventAction.new()
		event.action = "shift"
		event.pressed = false
		Input.parse_input_event(event)
	player.reset_colors()
	
	if world.music != null and world.music != $Music.stream:
		$Music.stream = world.music
		$Music.play()
	elif world.stop_music:
		$Music.stream = null


func wait(time: float):
	$Timer.start(time)
	await $Timer.timeout
