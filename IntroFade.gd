extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Fade In")
	
func _process(delta):
	if Input.is_action_just_pressed("space"):
			get_tree().change_scene("res://BasicLevel.gd")
	
