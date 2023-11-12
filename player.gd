extends CharacterBody2D
@export var playerSpeed = 100
var direction : Vector2 = Vector2.ZERO
var screenSize
@export var maxHealth = 3
@onready var currentHealth: int = maxHealth

signal hit
signal onPlayerAdded(playerId)
signal healthChanged

@export var playerId: int = 0
@onready var animationTree : AnimationTree = $AnimationTree

var interactableObject: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize = get_viewport_rect().size
	animationTree.active = true
	onPlayerAdded.emit(playerId)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_animation_parameters()
	
	direction = PlayerInput.getMovementDir(playerId)
	
	# Move collision shape location based on player input direction
	$InteractableObjectArea2D/CollisionShape2D.global_position = global_position + direction * 15
	
	if PlayerInput.is_action_pressed(playerId, PlayerInput.Action.Use) and not interactableObject == null:
		interactableObject.use()
	
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
	
func _on_hurt_box_area_entered(area):
	if area.name == "hitBox":
		currentHealth -= 1
		healthChanged.emit(currentHealth)
		print_debug("currentHealth")


func _on_interactable_object_area_2d_body_entered(body):
	if body.is_in_group("InteractableObject"):
		interactableObject = body
		# print("Encountered new interactable object")


func _on_interactable_object_area_2d_body_exited(body):
	if body == interactableObject:
		interactableObject = null
