extends CharacterBody2D


signal OK

var input: Vector2
var can_move: bool = true:
	set(value):
		can_move = value
		if value == false:
			velocity = Vector2.ZERO
			spr.frame_coords.x = 0
var typing_dlg: bool = false
var spd_mod: float = 1.0:
	set(value):
		spd_mod = value
		anim.speed_scale = value

@onready var spr = $Sprite
@onready var ray = $Ray
@onready var dlg = $UI/Margin/Dialogue
@onready var anim = $Animator


func _ready():
	$Background/Color.color = global.world.black
	$UI/Margin.size = Vector2(180, 8)
	reset_colors()


func _physics_process(_delta):
	move_and_slide()


func _input(event: InputEvent):
	if can_move:
		input = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), Input.get_action_strength("move_down") - Input.get_action_strength("move_up")).normalized()
		
		if event.is_action_pressed("shift"):
			spd_mod = 0.5
		elif event.is_action_released("shift"):
			if !global.world.force_slow:
				spd_mod = 1.0
		
		if input != Vector2.ZERO:
			velocity = input * 48 * spd_mod
			ray.target_position = input * 16
			
			$IdleTimer.stop()
			if input.x > 0:
				spr.frame_coords.y = 3
			elif input.x < 0:
				spr.frame_coords.y = 2
			elif input.y > 0:
				spr.frame_coords.y = 0
			elif input.y < 0:
				spr.frame_coords.y = 1
			anim.play("walk")
		else:
			velocity = Vector2.ZERO
			
			anim.stop()
			spr.frame_coords.x = 0
			$IdleTimer.start()
	if event.is_action_pressed("interact"):
		emit_signal("OK")
		if ray.is_colliding() and can_move:
			ray.get_collider().interact(self)
		elif typing_dlg:
			typing_dlg = false


func type_dialogue(text: String):
	can_move = false
	typing_dlg = true
	dlg.visible = true
	dlg.visible_characters = 0
	anim.play("raise_ui")
	
	for s in text.split("\n", false):
		dlg.visible_characters = 0
		typing_dlg = true
		dlg.text = s
		
		for i in s.length():
#			if !typing_dlg:
#				dlg.visible_characters = s.length()
#				break
			if s[dlg.visible_characters - 1] in [".", ",", "!", "?", "-", ":"]:
				await global.wait(0.2)
			else:
				await global.wait(0.02)
			dlg.visible_characters += 1
		
		await OK
	
	anim.play_backwards("raise_ui")
	await anim.animation_finished
	dlg.visible = false
	typing_dlg = false
	can_move = true


func reset_colors():
	create_tween().set_trans(Tween.TRANS_CUBIC).tween_property($Background/Color, "color", global.world.black, 0.2)
	dlg.add_theme_color_override("font_color", global.world.white)
	dlg.get_theme_stylebox("normal").border_color = global.world.white
	dlg.get_theme_stylebox("normal").bg_color = global.world.black
