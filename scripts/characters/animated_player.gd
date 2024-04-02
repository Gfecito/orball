extends AnimatedSprite2D

var player
var world

# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_tree().root.get_child(0)

func determine_direction() -> int:
	player = world.get_node("Player")
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
	
