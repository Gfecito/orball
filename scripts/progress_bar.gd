extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	value = 50


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gui_player_damaged():
	print("received damage signal to bar")
	value = 10


func _on_gui_player_grew():
	print("received growth signal to bar")
	value = 100
