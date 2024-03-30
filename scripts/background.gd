extends ParallaxBackground

var trees_sector = preload("res://scenes/foreground_sector.tscn")

func build_background(sector_width: float, sector_height: float) -> void:
	for sector_position in range(-10,10):
		var x = sector_width * sector_position
		for platform_position in range(1,100):
			var y = -1 * sector_height * platform_position
			add_background_sector(Vector2(x, y))

# `position` already exists in Node2D
func add_background_sector(_position: Vector2) -> void:
	var instance = trees_sector.instantiate()
	$"Foreground".add_child(instance)
	instance.set_global_position(_position)


# Called when the node enters the trees_sector tree for the first time.
func _ready():
	# Without this, pausing will freeze the background.
	# Might be desirable.
	process_mode = Node.PROCESS_MODE_ALWAYS
	build_background(1150, 600)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
