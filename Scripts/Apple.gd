extends KinematicBody2D

func CanMoveForward() -> bool:
	$DetectorPoint/RayCast2D.force_raycast_update()
	return not $DetectorPoint/RayCast2D.is_colliding()


func MoveApple(var jump_pixel):
	SetBestRoute()
	var direction = GetDirectionFromRotationDegree()
	print("Can move forward: ", CanMoveForward())
	if CanMoveForward():
		position += direction*jump_pixel


func SetBestRoute() -> void:
	$DetectorPoint/MovementTowards.enabled = true
	$DetectorPoint/MovementTowards.force_raycast_update()
	$DetectorPoint.rotation_degrees = 0
	
	var safe_length = [0, 0, 0, 0]
	print(safe_length)
	var origin = $DetectorPoint/MovementTowards.global_transform.origin
	
	#Check every direction for the longest line without collision
	for i in range(3):
		var collision_point = $DetectorPoint/MovementTowards.get_collision_point()
		var distance = origin.distance_to(collision_point)
		safe_length[i] = distance
		$DetectorPoint.rotation_degrees += 90
		$DetectorPoint/MovementTowards.force_raycast_update()
	
	#Get the index of longest line without collision in the array
	var best_route_index = safe_length.find(safe_length.max())
	print(safe_length, best_route_index)
	$DetectorPoint.rotation_degrees = 90*(best_route_index+1)
	$DetectorPoint/MovementTowards.enabled = false


func GetDirectionFromRotationDegree():
	match $DetectorPoint.rotation_degrees:
		0:
			return Vector2.UP
		90:
			return Vector2.RIGHT
		180:
			return Vector2.DOWN
		270:
			return Vector2.LEFT
