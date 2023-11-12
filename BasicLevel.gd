extends Node2D

var playerScene = preload("res://player.tscn")
@onready var heartsContainer = $CanvasLayer/HeartsContainer
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerInput.playerAdded.connect(addPlayer)
	heartsContainer.setMaxHearts(3)
	#heartsContainer.updateHearts(player.currentHealth)
	#player.healthChanged.connect(heartsContainer.updateHearts)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func addPlayer(playerId):
	var player = playerScene.instantiate()
	player.playerId = playerId
	player.position = $SpawnPoint.position
	add_child(player)
