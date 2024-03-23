extends ParallaxBackground

var trees_sector = preload("res://scenes/foreground_sector.tscn")

# `position` already exists in Node2D
func add_background_sector(_position: Vector2):
	var instance = trees_sector.instantiate()
	$"Foreground".add_child(instance)
	instance.set_global_position(_position)


# Called when the node enters the trees_sector tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Play music
	# Do this on signal from player
	for sector_position in range(-10,10):
		var x = 1150 * sector_position
		for platform_position in range(1,100):
			var y = -600 * platform_position
			add_background_sector(Vector2(x, y))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
