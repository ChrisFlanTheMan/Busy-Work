extends CharacterBody2D

var movement_speed: float = 200.0

var current_position_index: int = 0
var positions: Array = [
	Vector2(100.0,100.0),
	Vector2(100.0,500.0),
	Vector2(900.0,500.0),
	Vector2(600.0,250.0),
	Vector2(900.0,100.0)
]

var movement_target_position: Vector2 = positions[current_position_index]

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed

	velocity = new_velocity
	move_and_slide()


func _on_navigation_agent_2d_target_reached():
	var print_string: String = "npc reached target " + str(current_position_index)
	#print(print_string)
	if current_position_index == positions.size() - 1:
		current_position_index = 0
	else:
		current_position_index = current_position_index + 1
	await get_tree().create_timer(3.0).timeout
	set_movement_target(positions[current_position_index])
