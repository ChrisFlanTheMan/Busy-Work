extends Sprite2D

var counter = 0
var rotationMult = 0.001
var rotlength = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if counter < 20:
		rotation = sin(counter*rotationMult) 
		counter += 1
	
	if counter >= 20:
		counter = 0
		rotation = sin(counter*rotationMult) 
		
		


