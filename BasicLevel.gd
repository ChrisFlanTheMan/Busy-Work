extends Node2D

var playerScene = preload("res://player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerInput.playerAdded.connect(addPlayer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func addPlayer(playerId):
	var player = playerScene.instantiate()
	player.playerId = playerId
	player.position = $SpawnPoint.position
	add_child(player)
