class_name npcMovement
extends CharacterBody2D

var movement_speed: float = 200.0

@export var current_position_index: int = 0
@export var movement_position_markers_tag: String
var movement_position_markers: Array = []

var movement_target_position: Vector2
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	movement_position_markers = get_tree().get_nodes_in_group(movement_position_markers_tag)
	movement_target_position = movement_position_markers[current_position_index].position
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
	if not navigation_agent.is_navigation_finished():
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()

		var new_velocity: Vector2 = next_path_position - current_agent_position
		new_velocity = new_velocity.normalized()
		new_velocity = new_velocity * movement_speed

		velocity = new_velocity
		move_and_slide()


func _on_navigation_agent_2d_target_reached():
	var print_string: String = name + " reached target " + str(current_position_index)
	#print(print_string)
	if current_position_index == movement_position_markers.size() - 1:
		current_position_index = 0
	else:
		current_position_index = current_position_index + 1
	await get_tree().create_timer(2.5).timeout
	set_movement_target(movement_position_markers[current_position_index].position)
