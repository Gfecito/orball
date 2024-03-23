extends CharacterBody2D


@export var movement_speed = 300.0
@export var jump_velocity = -1000.0


# There must be a better way to pick this 
# than just by feeling, but its fine
const DOWNWARD_SPEED_THRESHOLD = 160


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var downward_speed = null
var can_double_jump = null

func _ready():
	can_double_jump = true
	downward_speed = 0
	process_mode = Node.PROCESS_MODE_PAUSABLE


func permit_jump():
	var jumped = Input.is_action_just_pressed("jump")
	if jumped:
		$"Jump".stop()		
		$"Jump".play()
		# Add jump sound
		velocity.y = jump_velocity

	return jumped

func allow_levitating_under_ground_level():
	if position.y  > 100:
		permit_jump()

func handle_movement(delta):
	allow_levitating_under_ground_level()
	if is_on_floor():
		if downward_speed > gravity * delta * DOWNWARD_SPEED_THRESHOLD:
			$"Landing".stop()
			$"Landing".play() # Just hit the ground
		can_double_jump = true
		permit_jump()
	else:
		if can_double_jump:
			can_double_jump = !permit_jump()
		# TODO: Modify project's gravity instead of this hack
		velocity.y += gravity * delta * 2 

	downward_speed = velocity.y
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
	
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Squirrel":
			print("I collided with ", collision.get_collider().name)
			hide()
			await get_tree().create_timer(2.0).timeout
			get_tree().reload_current_scene()

# func _physics_process(delta):
func _process(delta):
	handle_movement(delta)
	
#func _on_body_entered(body):
	#hide() # Owies we vanish on hit!
	# hit.emit()
