extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	# process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		visible = !visible

