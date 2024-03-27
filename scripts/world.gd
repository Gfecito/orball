extends Node2D

var ground_sector = preload("res://scenes/map_sector.tscn")
var platforms_sector = preload("res://scenes/platforms.tscn")

# `position` already exists in Node2D
func add_sector(_position: Vector2):
	var instance = ground_sector.instantiate()
	add_child(instance)
	instance.set_global_position(_position)

func add_platforms(_position: Vector2):
	var instance = platforms_sector.instantiate()
	add_child(instance)
	instance.set_global_position(_position)

# Called when the node enters the ground_sector tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Play music
	# Do this on signal from player
	for sector_position in range(-10,10):
		var x = 1150 * sector_position
		add_sector(Vector2(x,0))
		for platform_position in range(1,100):
			var y = -600 * platform_position
			add_platforms(Vector2(x, y))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused


func _on_gui_pause():
	get_tree().paused = !get_tree().paused


func _on_gui_reset():
	reset()

func reset():
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()


func _on_player_player_died():
	reset()
