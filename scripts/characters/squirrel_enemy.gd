extends CharacterBody2D

@export var movement_speed = 220.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var unleashed = false
var turned = false

func fetch_player():
	player = get_tree().root.get_child(0).get_node("Player")

func _ready():
	# This can be paused.
	process_mode = Node.PROCESS_MODE_PAUSABLE 
	
	# Wait a couple of seconds before moving in
	await get_tree().create_timer(1.0).timeout
	unleashed = true

func determine_direction() -> int:
	var my_position = global_position
	if !is_instance_valid(player) || !player:
		fetch_player()
		#print(player)
		return 0
	var player_position = player.global_position
	
	if abs(player_position.x - my_position.x) < 5:
		return 0
	if player_position.x > my_position.x:
		return 1
	if player_position.x < my_position.x:	
		return -1
	return 0

func handle_movement(_delta) -> void:
	if !is_instance_valid(player) || !player:
		fetch_player()
		#print(player)
		return
	# Get the input direction and handle the movement/deceleration.
	var direction = determine_direction()

	if !is_on_floor():
		velocity.y += gravity * _delta
	
	if direction:
		velocity.x = direction * movement_speed
		
		# If not already looking in that direction
		var should_turn = (sign(direction) == -1) && !turned || (sign(direction) == 1) && turned
		if should_turn:
			# Turn around
			turned = !turned
			scale.x = abs(scale.x) * -1
	else:
		velocity.x = 0
	
	move_and_slide()
	if get_last_slide_collision() && get_last_slide_collision().get_collider():
		var collider_name = get_last_slide_collision().get_collider().name
		if collider_name == player.name:
			player.collide_with(self)
		

func _process(delta):
	if unleashed:
		handle_movement(delta)
