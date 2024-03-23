extends AnimatedSprite2D

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	var world_node = get_tree().root.get_child(0)
	player = world_node.get_node("Player")
	world_node.print_tree_pretty()
	# TODO: Is this needed?
	process_mode = Node.PROCESS_MODE_PAUSABLE 

func determine_direction():
	var player_position = player.position
	var this_position = position
	if player_position.x == this_position.x:
		return 0
	if player_position.x > this_position.x:
		return 1
	else:
		return -1
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var direction = determine_direction()
	if direction != 0:
		scale.x = abs(scale.x) * direction
	
