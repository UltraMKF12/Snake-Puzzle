extends KinematicBody2D

var bodyPartBehind

func MoveBody(var newPostion):
	var oldPosition = position
	position = newPostion
	bodyPartBehind.MoveBody(oldPosition)
