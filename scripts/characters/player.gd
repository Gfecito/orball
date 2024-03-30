extends CharacterBody2D

signal player_died
signal jump
signal grounded

@export var movement_speed = 300.0
@export var jump_velocity = -1000.0


# There must be a better way to pick this 
# than just by feeling, but its fine
const DOWNWARD_SPEED_THRESHOLD = 80
const MAX_CONSECUTIVE_JUMPS = 3


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var downward_speed = 0
var jump_counter = MAX_CONSECUTIVE_JUMPS

func _ready():
	# This can be paused.
	process_mode = Node.PROCESS_MODE_PAUSABLE 

func _on_jump() -> void:
	if jump_counter > 0:
		$"Jump".stop()		
		$"Jump".play()
		velocity.y = jump_velocity
		jump_counter -= 1

func _on_grounded() -> void:
	jump_counter = MAX_CONSECUTIVE_JUMPS

func check_loud_landing(delta) -> void:
	if downward_speed > gravity * delta * DOWNWARD_SPEED_THRESHOLD:
			$"Landing".stop()
			$"Landing".play()

func allow_levitating_under_ground_level() -> void:
	if position.y  > 100:
		_on_grounded()

func move_vertically(delta) -> void:
	if Input.is_action_just_pressed("jump"):
		emit_signal("jump")

	allow_levitating_under_ground_level()
	if is_on_floor():
		check_loud_landing(delta)
		emit_signal("grounded")
	else:
		velocity.y += gravity * delta

	downward_speed = velocity.y

func move_horizontally(delta) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
	
	move_and_slide()

func handle_movement(delta) -> void:
	move_vertically(delta)
	move_horizontally(delta)
	
	detect_and_log_collisions()

func detect_and_log_collisions() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Squirrel":
			#print("I collided with ", collision.get_collider().name)
			hide()
			emit_signal("player_died")

func _process(delta):
	handle_movement(delta)
