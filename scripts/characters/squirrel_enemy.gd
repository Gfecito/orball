extends CharacterBody2D

@export var movement_speed = 250.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var world
var unleashed = false

func _ready():
	world = get_tree().root.get_child(0)
	# This can be paused.
	process_mode = Node.PROCESS_MODE_PAUSABLE 
	
	# Wait a couple of seconds before moving in
	await get_tree().create_timer(1.0).timeout
	unleashed = true

func determine_direction() -> int:
	player = world.get_node("Player")	
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

	if !is_on_floor():
		velocity.y += gravity * _delta
	
	if direction:
		velocity.x = direction * movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
	
	move_and_slide()

func _process(delta):
	if unleashed:
		handle_movement(delta)
