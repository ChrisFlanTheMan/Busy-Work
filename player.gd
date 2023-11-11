extends RigidBody2D
var playerSpeed = 3
var screenSize
signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize = get_viewport_rect().size


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
		
	position.x = clamp(position.x, 0, screenSize.x)
	position.y = clamp(position.y, 0, screenSize.y)
	
func _on_body_entered(body):
	print("Collision")
