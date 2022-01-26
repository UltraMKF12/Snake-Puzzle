extends KinematicBody2D

func RotateCollisionChecker(var degree, var direction, var jump_pixel) -> bool:
	$DetectorPoint.rotation_degrees = degree
	$DetectorPoint/RayCast2D.force_raycast_update()
	
	#If its a box try to move the box with the other box. The snake can push more than one box
	var object = $DetectorPoint/RayCast2D.get_collider()
	if object != null and object.is_in_group("Box"):
		if not object.RotateCollisionChecker(degree, direction, jump_pixel):
			object.MoveBox(direction, jump_pixel)
			return false
	
	return $DetectorPoint/RayCast2D.is_colliding()

func MoveBox(var direction, var jump_pixel):
	position += direction*jump_pixel
