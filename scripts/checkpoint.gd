extends Area2D

signal save_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	print("BODY ENTERED", body.name)
	if body.name == "Player":
		emit_signal("save_game")


func _on_body_exited(body):
	print("BODY EXITED", body.name)
