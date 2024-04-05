extends ProgressBar

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().root.get_child(0).get_node("Player")
	set_min(player.MIN_SCALE.x/player.MAX_SCALE.x * 100)
	set_max(100)
	value = (player.scale.x / player.MAX_SCALE.x) * 100
	print("MIN: " + str(min_value) + " MAX: " + str(max_value) + " value: " + str(value))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func health():
	return (player.scale.x / player.MAX_SCALE.x) * 100


func _on_gui_player_damaged():
	print("received damage signal to bar")
	set_value(health())
	#value = 10


func _on_gui_player_grew():
	print("received growth signal to bar")
	set_value(health())
	#value = 100
