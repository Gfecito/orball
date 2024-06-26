extends CharacterBody2D

signal player_died
signal jump
signal grounded
signal damaged
signal grew

enum Mutation {
	STANDARD,
	SQUIRREL
}

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var downward_speed = 0
@export var jump_counter = MAX_STANDARD_JUMPS
@export var turned = false
@export var movement_speed = 300.0
@export var jump_velocity = -1000.0
@export var current_mutation = Mutation.STANDARD
var health = 100
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var hurtable = true
var camera
var sound_playing = false



# I CHOSE THESE ARBITRARILY
const DOWNWARD_SPEED_THRESHOLD = 80
const MAX_STANDARD_JUMPS = 3
const MAX_HEALTH = 500

var max_consecutive_jumps = MAX_STANDARD_JUMPS


func _ready():
	# Player can be paused.
	process_mode = Node.PROCESS_MODE_PAUSABLE
	camera = $"DynamicCamera"

func playSoundAgain():
	sound_playing = false  # Reset the sound_playing flag
	$"Walk".stop()

func _on_jump() -> void:
	if jump_counter > 0:
		$"Jump".stop()		
		$"Jump".play()
		velocity.y = jump_velocity
		jump_counter -= 1

func _on_grounded() -> void:
	jump_counter = max_consecutive_jumps

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
		if !sound_playing:  # Check if sound is not already playing
			$"Walk".play()
			sound_playing = true
			# Start the timer to wait for the sound to finish
			$SoundTimer.start()
		velocity.x = direction * movement_speed
		$AnimationPlayer.play("walk")
		# If not already looking in that direction
		var should_turn = (sign(direction) == -1) && !turned || (sign(direction) == 1) && turned
		if should_turn:
			# Turn around
			turned = !turned
			scale.x = abs(scale.x) * -1
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
	
	move_and_slide()

func handle_movement(delta) -> void:
	move_vertically(delta)
	move_horizontally(delta)
	
	detect_collisions()

func eat(victim):
	if health < MAX_HEALTH:
		$"Eat".stop()
		$"Eat".play()
		var new_zoom = camera.get_zoom() - Vector2(0.01, 0.01)
		camera.set_zoom(new_zoom)
		health = clamp(health + 10, 0, MAX_HEALTH)
		print("ATE, HAS HEALTH: " + str(health) + ", ZOOM: " + str(camera.get_zoom()) + ", SCALE: " + str(scale))
		var new_scale = scale * Vector2(1.01, 1.01)
		set_scale(new_scale)
		emit_signal("grew")
	victim.queue_free()

func shed(percentage: float):
	var scaling = percentage / 1000
	if health > 0:
		$"Shed".stop()
		$"Shed".play()
		health = clamp(health - percentage, 0, MAX_HEALTH)
		print("SHED, HAS HEALTH: " + str(health) + ", ZOOM: " + str(camera.get_zoom()) + ", SCALE: " + str(scale))
		# Make smaller
		var new_scale = scale * Vector2((1-scaling), (1-scaling))
		set_scale(new_scale)
		# Zoom in
		var new_zoom = camera.get_zoom() + Vector2(scaling, scaling)
		camera.set_zoom(new_zoom)
		emit_signal("damaged")

func get_hurt():
	if !hurtable:
		return
	untouchable()
	if health <= 0:
		hide()
		emit_signal("player_died")
	else:
		shed(30)

func untouchable():
	modulate.a = 0.4
	hurtable = false
	$"OnHitInvincibilityTimer".start()

func damageable():
	modulate.a = 1
	hurtable = true

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"downward_speed" : downward_speed,
		"name" : name,
		"jump_counter" : jump_counter,
		"turned" : turned,
		"movement_speed" : movement_speed,
		"jump_velocity" : jump_velocity,
		"current_mutation" : current_mutation,
		"health" : health,
		"gravity" : gravity
	}
	return save_dict
	

func _on_hit_invincibility_timer_timeout():
	damageable()

func collide_with(object):
	match object.name:
		"Squirrel":
			if Input.is_action_pressed("eat"):
				eat(object)
				mutate(Mutation.SQUIRREL)
			else:
				get_hurt()
				mutate(Mutation.STANDARD)
		_:
			# Handle other cases if needed
			pass

func mutate(variant: Mutation):
	current_mutation = variant
	match variant:
		Mutation.SQUIRREL:
			max_consecutive_jumps = MAX_STANDARD_JUMPS + 3
		Mutation.STANDARD:
			max_consecutive_jumps = MAX_STANDARD_JUMPS
		_:
			pass

func detect_collisions() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		collide_with(collision.get_collider())

func _process(delta):
	handle_movement(delta)
