extends AnimatedSprite2D

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	var world_node = get_tree().root.get_child(0)
	player = world_node.get_node("Player")
	world_node.print_tree_pretty()
	# TODO: Is this needed?
	process_mode = Node.PROCESS_MODE_PAUSABLE 


		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		scale.x = abs(scale.x) * direction
	
