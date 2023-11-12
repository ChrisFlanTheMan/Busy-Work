extends HBoxContainer

@onready var HeartGUIClass = preload("res://scenes/heartGUI.tscn")

signal health_changed
signal health_depleted

@export var maxHealth = 3
var currentHealth

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func setMaxHearts(max: int):
	for i in range(max):
		var heart = HeartGUIClass.instantiate()
		add_child(heart)
