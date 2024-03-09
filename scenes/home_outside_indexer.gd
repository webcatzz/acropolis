extends Area2D




func on_body_entered(body: Node2D):
	if body.name == "Player":
		body.z_index += 1


func on_body_exited(body: Node2D):
	if body.name == "Player":
		body.z_index -= 1
