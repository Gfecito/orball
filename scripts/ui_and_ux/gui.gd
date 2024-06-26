extends CanvasLayer

signal pause
signal reset
signal save
signal load

signal player_damaged
signal player_grew


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pause():
	emit_signal("pause")

func _on_pause_menu_reset():
	emit_signal("reset")


func _on_signal_coordinator_player_grew():
	print("received growth signal to gui")
	emit_signal("player_grew")


func _on_signal_coordinator_player_damaged():
	print("received damage signal to gui")	
	emit_signal("player_damaged")


func _on_save_button_pressed():
	print("sending save signal from gui")
	emit_signal("save")

func _on_load_button_pressed():
	print("sending load signal from gui")
	emit_signal("load")
