extends CharacterBody2D


@export var speed = 300.0
@export var jump_velocity = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")*2

var can_double_jump = false	

func permit_jump():
	var POSITIONAL_JUMP_SOUND_EFFECTS = [$"Jump1", $"Jump2"]

	var jumped = Input.is_action_just_pressed("jump")
	if jumped:
		var random_sound_effect = POSITIONAL_JUMP_SOUND_EFFECTS.pick_random()
		random_sound_effect.play()
		# Add jump sound
		velocity.y = jump_velocity
	return jumped

func _physics_process(delta):
	if position.y  > 100:
		permit_jump()
	if is_on_floor():
		if !can_double_jump:
			$"Jump3".play() # Just hit the ground
		can_double_jump = true
		permit_jump()
	else:
		if can_double_jump:
			can_double_jump = !permit_jump()
		velocity.y += gravity * delta
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
