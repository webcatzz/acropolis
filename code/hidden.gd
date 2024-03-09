extends ColorRect


@onready var flag: String = global.world.get_scene_name() + "_" + name.to_lower()


func _ready():
	if flag in global.data.flags:
		queue_free()
	else:
		color = global.world.black
		$Area.position = size / 2
		$Area/Shape.shape.size = size


func on_body_entered(body: Node2D):
	global.data.flags.append(flag)
	await create_tween().set_trans(Tween.TRANS_CUBIC).tween_property(self, "color:a", 0, 0.2).finished
	queue_free()
