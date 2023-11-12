extends "res://npcMovement.gd"

@export var spawnPosition: Marker2D

@onready var hasCake = false
@onready var area2D = $Area2D;

var raycast: RayCast2D

func _ready():
	super()
	raycast = RayCast2D.new()
	add_child(raycast)
	
func _boss_speech(visible):
	if visible:
		if hasCake:
			$Area2D/backtowork.visible = true
		else:
			$Area2D/nocake.visible = true
	else:
		$Area2D/backtowork.visible = false
		$Area2D/nocake.visible = false

func _physics_process(delta):
	super(delta)
	var nodes = area2D.get_overlapping_bodies()
	for node in nodes:
		if node.is_in_group("Player"):
			raycast.target_position = node.position - position

			if raycast.is_colliding():
				var collider = raycast.get_collider()
				if (collider.is_in_group("Player")):
					if (collider.suspicion > 3 * delta):
						self._boss_speech(true)
					collider.addSuspicion(delta)
					if (collider.suspicion > collider.MAX_SUSPICION):
						self._boss_speech(false)
						collider.position = spawnPosition.position
						collider.suspicion = 0
