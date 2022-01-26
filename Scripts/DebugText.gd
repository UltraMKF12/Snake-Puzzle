extends Label

func _process(_delta):
	var collisions = $"../SnakeHead/DetectorPoint/RayCast2D".is_colliding()
	if collisions:
		text = "True"
	else:
		text = "False"
