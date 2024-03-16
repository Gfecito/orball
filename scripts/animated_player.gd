extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		scale.x = abs(scale.x) * direction
	
