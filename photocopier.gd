extends Node2D

func use():
	if not $AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.play("active")
