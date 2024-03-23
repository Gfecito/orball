extends CharacterBody2D


@export var movement_speed = 300.0

func _ready():
	# TODO: Is this needed?
	process_mode = Node.PROCESS_MODE_PAUSABLE 

func determine_direction():
	return Input.get_axis("move_left", "move_right")

func handle_movement(delta):
	# Get the input direction and handle the movement/deceleration.
	var direction = determine_direction()
	if direction:
		velocity.x = direction * movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
	
	move_and_slide()

# func _physics_process(delta):
func _process(delta):
	handle_movement(delta)
	
