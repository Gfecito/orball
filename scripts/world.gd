extends Node2D

var ground_sector = preload("res://scenes/map_sector.tscn")
var platforms_sector = preload("res://scenes/platforms.tscn")

const MAX_SECTORS = 3
const MAX_PLATFORM_HEIGHT = 50
const SECTOR_WIDTH = 1150
const SECTOR_HEIGHT = 600

# Procedural generation progress trackers.
var current_sector = 0
var current_platform = 0
var current_platform_level = 1
var sector_build_complete = false
var platform_build_complete = false

func reset() -> void:
	# Get tree seems to be able to flake sometimes.
	# We should add some safeguards
	get_tree().paused = false
	if get_tree():
		get_tree().reload_current_scene()

func build_next_sector() -> void:
	var x = SECTOR_WIDTH * current_sector
	# Add symmetrically
	add_sector(Vector2(x, 0))
	add_sector(Vector2(-1 * x, 0))
	current_sector += 1
	if current_sector > MAX_SECTORS:
		sector_build_complete = true

func build_next_platform() -> void:
	var x = SECTOR_WIDTH * current_platform
	var y = -1 * SECTOR_HEIGHT * current_platform_level
	# Add symmetrically
	add_platforms(Vector2(x, y))
	add_platforms(Vector2(-1 * x, y))
	if current_platform > MAX_SECTORS:
		if current_platform_level > MAX_PLATFORM_HEIGHT:
			platform_build_complete = true
		else:
			current_platform_level += 1
			current_platform = 0
	else:
		current_platform += 1

# `position` already exists in Node2D
func add_sector(_position: Vector2) -> void:
	var instance = ground_sector.instantiate()
	add_child(instance)
	instance.set_global_position(_position)

func add_platforms(_position: Vector2) -> void:
	var instance = platforms_sector.instantiate()
	add_child(instance)
	instance.set_global_position(_position)

func _ready():
	# Without this, pausing will freeze the game.
	process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !sector_build_complete:
		build_next_sector()
	if !platform_build_complete:
		build_next_platform()



func _on_pause() -> void:
	get_tree().paused = !get_tree().paused


func _on_reset() -> void:
	reset()

func _on_player_player_died() -> void:
	await get_tree().create_timer(2.0).timeout
	reset()
