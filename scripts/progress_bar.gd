extends ProgressBar

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().root.get_child(0).get_node("Player")
	set_min(0)
	set_max(player.MAX_HEALTH)
	value = player.health
	print("MIN: " + str(min_value) + " MAX: " + str(max_value) + " value: " + str(value))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func health():
	var current_health = player.health
	print("Current health: " + str(current_health))
	return current_health


func _on_gui_player_damaged():
	print("received damage signal to bar")
	set_value(health())
	#value = 10


func _on_gui_player_grew():
	print("received growth signal to bar")
	set_value(health())
	#value = 100
