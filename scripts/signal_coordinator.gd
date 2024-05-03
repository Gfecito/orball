extends Node

signal player_died

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


func _on_player_player_died():
	emit_signal("player_died")


func _on_pause():
	emit_signal("pause")


func _on_reset():
	emit_signal("reset")


func _on_player_damaged():
	print("player damaged")	
	emit_signal("player_damaged")


func _on_player_grew():
	print("player grew")
	emit_signal("player_grew")


func _on_gui_save():
	emit_signal("save")


func _on_gui_load():
	emit_signal("load")
