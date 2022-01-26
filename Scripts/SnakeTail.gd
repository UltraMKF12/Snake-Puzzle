extends KinematicBody2D

var bodyPartForward

func MoveBody(var newPostion):
	position = newPostion

	#Going left
	if bodyPartForward.position.x < position.x:
		$Sprite.rotation_degrees = 270
		
	#Going right
	if bodyPartForward.position.x > position.x:
		$Sprite.rotation_degrees = 90
	
	#Going up
	if bodyPartForward.position.y < position.y:
		$Sprite.rotation_degrees = 0
	
	#Going down
	if bodyPartForward.position.y > position.y:
		$Sprite.rotation_degrees = 180
	
