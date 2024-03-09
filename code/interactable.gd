extends Area2D


signal interacted_with

@export_multiline var dialogue: String
@export var size: Vector2 = Vector2(1, 1)


func _ready():
	$Shape.position = size * 4
	$Shape.shape.size = size * 8


func interact(player: Node2D):
	if !dialogue.is_empty():
		player.type_dialogue(dialogue)
	emit_signal("interacted_with")
