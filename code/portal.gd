extends Area2D


@export var color: Color = Color.WHITE
@export_enum("Top", "Bottom", "Left", "Right") var use_side: int
@export var size: Vector2
var pxl_size: Vector2

var ticked: bool = false


func _ready():
	pxl_size = size * 8
	$Shape.shape.b = pxl_size
	$Color.color = color
	
	match use_side:
		0:
			$Collision/Shape.shape.size = Vector2(pxl_size.x, 4)
			$Collision.position = Vector2(pxl_size.x / 2, 6)
			
			$Color.size = Vector2(pxl_size.x - 2, 2)
		1:
			$Collision/Shape.shape.size = Vector2(pxl_size.x, 4)
			$Collision.position = Vector2(pxl_size.x / 2, -6)
			$Collision.rotation = PI
			
			$Color.size = Vector2(pxl_size.x - 2, 2)
			$Color.position.y = pxl_size.y - 3
		2:
			$Collision/Shape.shape.size = Vector2(4, pxl_size.y)
			$Collision.position = Vector2(6, pxl_size.y / 2)
			$Collision.rotation = PI * 1.5
			
			$Color.size = Vector2(2, pxl_size.y - 2)
		3:
			$Collision/Shape.shape.size = Vector2(4, pxl_size.y)
			$Collision.position = Vector2(-6, pxl_size.y / 2)
			$Collision.rotation = PI * 0.5
			
			$Color.size = Vector2(2, pxl_size.y - 2)
			$Color.position.x = pxl_size.x - 3


func on_body_entered(body: Node2D):
	if ticked:
		ticked = false
	else:
		if body.name == "Player":
			global.portal(name, self)
