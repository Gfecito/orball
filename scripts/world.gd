extends Node2D

var ground_sector = preload("res://scenes/map_sector.tscn")
var final_ground_sector = preload("res://scenes/map_sector_final.tscn")
var platforms_sector = preload("res://scenes/platforms.tscn")

const MAX_SECTORS = 3
const MAX_PLATFORM_HEIGHT = 3
const SECTOR_WIDTH = 1150
const SECTOR_HEIGHT = 600

const SAVE_PATH = "user://savegame.save"


# Procedural generation progress trackers.
var current_level = 1
var current_sector = 0
var current_platform = 0
var current_platform_level = 1
var sector_build_complete = false
var platform_build_complete = false

func reset() -> void:
	# Get tree seems to be able to flake sometimes.
	# We should add some safeguards
	if get_tree():
		get_tree().paused = false
		get_tree().reload_current_scene()

func build_next_sector() -> void:
	var x = SECTOR_WIDTH * current_sector
	# Add symmetrically
	add_sector(Vector2(x, 0))
	current_sector += 1
	if current_sector > MAX_SECTORS:
		sector_build_complete = true

func build_next_platform() -> void:
	var x = SECTOR_WIDTH * current_platform
	var y = -1 * SECTOR_HEIGHT * current_platform_level
	# Add symmetrically
	add_platforms(Vector2(x, y))
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
	var instance
	match current_level:
		1:
			if(current_sector == MAX_SECTORS): 
				instance = final_ground_sector.instantiate()
				instance.find_child("Area2D").save_game.connect(save)
			else:
				instance = ground_sector.instantiate()
		var undefined_level:
			print("Current level is not recognized: ", undefined_level)
	add_child(instance)
	instance.set_global_position(_position)

func add_platforms(_position: Vector2) -> void:
	var instance
	match current_level:
		1:
			instance = platforms_sector.instantiate()
		var undefined_level:
			print("Current level is not recognized: ", undefined_level)
	add_child(instance)
	instance.set_global_position(_position)

func _ready():
	# Without this, pausing will freeze the game.
	process_mode = Node.PROCESS_MODE_ALWAYS

func build_level():
	if !sector_build_complete:
		build_next_sector()
	if !platform_build_complete:
		build_next_platform()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	build_level()

func save():
	print("SAVING...")
	var save_game = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(json_string)

func load_data():
	print("LOADING...")
	if not FileAccess.file_exists(SAVE_PATH):
		print("NO GAME SAVED FOUND")
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	#for i in save_nodes:
		#i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_game = FileAccess.open(SAVE_PATH, FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(new_object)
		# TODO(SANTI): THIS IS TRIVIALLY WRONG THE +20 IS IN USE FOR TESTING BUT
		# SHOULD BE REMOVED.
		new_object.position = Vector2(node_data["pos_x"]+20, node_data["pos_y"]+20)

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])



func _on_pause() -> void:
	load_data()
	get_tree().paused = !get_tree().paused


func _on_reset() -> void:
	reset()

func _on_player_player_died() -> void:
	await get_tree().create_timer(2.0).timeout
	reset()
