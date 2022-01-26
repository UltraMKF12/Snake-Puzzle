extends KinematicBody2D

const SnakeBody = preload("res://Scenes/SnakeBody.tscn")
const SnakeTail = preload("res://Scenes/SnakeTail.tscn")

var jump_pixel = 64
var direction = Vector2(0, 0)
var bodyPartBehind
var movable = true

export(int, 1, 10) var bodyNumber


func _ready():
	var root = get_tree().get_current_scene()
	
	#Making the first body
	var newBodyElement = SnakeBody.instance()
	root.call_deferred("add_child", newBodyElement)
	newBodyElement.position = position
	bodyPartBehind = newBodyElement
	
	
	#Adding additional bodies - also linking them together
	var bodyPartForward = newBodyElement
	for _i in range(bodyNumber):
		newBodyElement = SnakeBody.instance()
		root.call_deferred("add_child", newBodyElement)
		newBodyElement.position = position
		bodyPartForward.bodyPartBehind = newBodyElement
		bodyPartForward = newBodyElement
	
	
	#Adding the tail
	newBodyElement = SnakeTail.instance()
	root.call_deferred("add_child", newBodyElement)
	bodyPartForward.bodyPartBehind = newBodyElement
	newBodyElement.position = position
	newBodyElement.bodyPartForward = bodyPartForward
	


func _process(_delta):
	if Input.is_action_pressed("left") and movable:
		DisableMovement()
		direction = Vector2.LEFT
		var is_colliding = RotateCollisionChecker(270)
		if not is_colliding:
			MoveSnake()
		
	if Input.is_action_pressed("right") and movable:
		DisableMovement()
		direction = Vector2.RIGHT
		var is_colliding = RotateCollisionChecker(90)
		if not is_colliding:
			MoveSnake()
		
	if Input.is_action_pressed("up") and movable:
		DisableMovement()
		direction = Vector2.UP
		var is_colliding = RotateCollisionChecker(0)
		if not is_colliding:
			MoveSnake()
		
	if Input.is_action_pressed("down") and movable:
		DisableMovement()
		direction = Vector2.DOWN
		var is_colliding = RotateCollisionChecker(180)
		if not is_colliding:
			MoveSnake()


func MoveSnake():
	position += direction*jump_pixel
	direction = Vector2.ZERO
	bodyPartBehind.MoveBody(position)


func DisableMovement():
	#Without timer the snake moves toooooo fast.
	movable = false
	$MovableTimer.start()


func RotateCollisionChecker(var degree) -> bool:
	$DetectorPoint.rotation_degrees = degree
	$DetectorPoint/RayCast2D.force_raycast_update()
	
	#Check for apple
	$DetectorPoint/RayCastApple.force_raycast_update()
	if $DetectorPoint/RayCastApple.is_colliding():
		$DetectorPoint/RayCastApple.get_collider().MoveApple(jump_pixel)
	
	#If its a box try to move the box with the snake
	var object = $DetectorPoint/RayCast2D.get_collider()
	if object != null:
		if object.is_in_group("Box"):
			if not object.RotateCollisionChecker(degree, direction, jump_pixel):
				object.MoveBox(direction, jump_pixel)
				return false
		
	return $DetectorPoint/RayCast2D.is_colliding()


func _on_MovableTimer_timeout():
	movable = true
