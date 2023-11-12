extends "res://npcMovement.gd"

@export var spawnPosition: Marker2D

@onready var area2D = $Area2D;

var raycast: RayCast2D

func _ready():
	super()
	raycast = RayCast2D.new()
	add_child(raycast)

func _physics_process(delta):
	super(delta)
	var nodes = area2D.get_overlapping_bodies()
	for node in nodes:
		if node.is_in_group("Player"):
			raycast.target_position = node.position - position

			if raycast.is_colliding():
				var collider = raycast.get_collider()
				if (collider.is_in_group("Player")):
					$Area2D/backtowork.visible = not $Area2D/backtowork.visible
					$Area2D/nocake.visible = not $Area2D/nocake.visible
					collider.addSuspicion(delta)
					if (collider.suspicion > collider.MAX_SUSPICION):
						collider.position = spawnPosition.position
						collider.suspicion = 0
