extends CharacterBody2D


@export var movement_speed = 250.0
var player

func _ready():
	var world_node = get_tree().root.get_child(0)
	player = world_node.get_node("Player")

	# This can be paused.
	process_mode = Node.PROCESS_MODE_PAUSABLE 

func determine_direction() -> int:
	var player_position = player.position
	var this_position = position
	if abs(player_position.x - this_position.x) < 5:
		return 0
	if player_position.x > this_position.x:
		return 1
	else:
		return -1

func handle_movement(_delta) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction = determine_direction()
	
	if direction:
		velocity.x = direction * movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
	
	move_and_slide()

func _process(delta):
	handle_movement(delta)
