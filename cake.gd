extends Area2D

var num_frames
var current_frame = 0

func _ready():
	num_frames = $AnimatedSprite2D.get_sprite_frames().get_frame_count("default")

func _on_body_entered(body):
	if current_frame != num_frames:
		current_frame = (current_frame + 1)
		$AnimatedSprite2D.set_frame(current_frame)
