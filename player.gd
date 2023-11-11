extends Node2D
var playerSpeed = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("Up"):
		position.y -= playerSpeed
	if Input.is_action_pressed("Down"):
		position.y += playerSpeed
	if Input.is_action_pressed("Left"):
		position.x -= playerSpeed
	if Input.is_action_pressed("Right"):
		position.x += playerSpeed
