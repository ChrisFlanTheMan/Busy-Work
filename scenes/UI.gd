extends Control
class_name UI

@onready var playerHeartContainers = "res://scenes/heartsContainer.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	player.onPlayerAdded.connect(addPlayerHealth)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	playerHeartContainers
	
func addPlayerHealth(playerId):
	
