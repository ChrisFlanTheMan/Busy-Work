extends CharacterBody2D
@export var playerSpeed = 100
var direction : Vector2 = Vector2.ZERO
var screenSize
signal hit

@onready var animationTree : AnimationTree = $AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize = get_viewport_rect().size
	animationTree.active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_animation_parameters()
	
	direction = Input.get_vector("Left", "Right", "Up", "Down").normalized()
	
	if direction:
		velocity = direction * playerSpeed
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()
		
	position.x = clamp(position.x, 0, screenSize.x)
	position.y = clamp(position.y, 0, screenSize.y)
	
func _on_body_entered(body):
	print("Collision")
	
func update_animation_parameters():
	if(velocity == Vector2.ZERO):
		animationTree["parameters/conditions/idle"] = true
		animationTree["parameters/conditions/is_moving"] = false
	else:
		animationTree["parameters/conditions/idle"] = false
		animationTree["parameters/conditions/is_moving"] = true
		
	if(direction != Vector2.ZERO):
		animationTree["parameters/Idle/blend_position"] = direction
		animationTree["parameters/Walk/blend_position"] = direction
	
