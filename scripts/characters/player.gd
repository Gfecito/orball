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

const MIN_ZOOM = Vector2(0.4,0.4)
const MAX_ZOOM = Vector2(4,4)
const MIN_SCALE = Vector2(0.5,0.5)
const MAX_SCALE = Vector2(5,5)


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
	if Input.is_action_just_pressed("shed"):
		shed(20)
	
	detect_and_log_collisions()

func eat(victim):
	print("I EAT RIGHT NOW")
	$"Eat".stop()
	$"Eat".play()
	var camera = $"DynamicCamera"
	# When this gets negative the camera flips!
	# Lets multiply
	var new_zoom = clamp(camera.get_zoom()*Vector2(0.9, 0.9), MIN_ZOOM, MAX_ZOOM)
	camera.set_zoom(new_zoom)
	if scale < MAX_SCALE:
		apply_scale(Vector2(1.1,1.1))
	victim.queue_free()

func shed(percentage: float):
	print("I SHED RIGHT NOW")
	$"Shed".stop()
	$"Shed".play()
	var to_keep = 1.0-(percentage/100)
	var camera = $"DynamicCamera"
	var new_zoom = clamp(camera.get_zoom() * Vector2(1.25, 1.25), MIN_ZOOM, MAX_ZOOM)
	camera.set_zoom(new_zoom)
	if scale > MIN_SCALE:
		apply_scale(Vector2(to_keep,to_keep))


func detect_and_log_collisions() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Squirrel":
			#print("I collided with ", collision.get_collider().name)
			if Input.is_action_pressed("eat"):
				eat(collision.get_collider())
			else:
				hide()
				emit_signal("player_died")

func _process(delta):
	handle_movement(delta)
