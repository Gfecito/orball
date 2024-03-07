extends Node2D

var scene = preload("res://scenes/map_sector.tscn")

# `position` already exists in Node2D
func add_sector(_position: Vector2):
	var instance = scene.instantiate()
	add_child(instance)
	instance.set_global_position(_position)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Play music
	# Do this on signal from player
	for sector_position in range(1,10):
		add_sector(Vector2(1150*sector_position,0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
