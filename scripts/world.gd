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
	# Play music
	# Do this on signal from player
	for sector_position in range(1,10):
		var x = 1150 * sector_position
		add_sector(Vector2(x,0))
		for platform_position in range(1,10):
			var y = -600 * platform_position
			add_platforms(Vector2(x, y))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
