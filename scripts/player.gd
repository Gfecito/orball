extends CharacterBody2D


@export var speed = 300.0
@export var jump_velocity = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")*2

var can_double_jump = false	

func permit_jump():
	if Input.is_action_just_pressed("jump"):
		# Add jump sound
		# If on floor, we recover our double jumps
		can_double_jump = is_on_floor()
		print(can_double_jump)
		velocity.y = jump_velocity

func _physics_process(delta):
	if is_on_floor():
		permit_jump()
	else:
		if can_double_jump:
			permit_jump()
		velocity.y += gravity * delta
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
