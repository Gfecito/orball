extends VSlider

@export 
var bus_name: String

var bus_index: int
var current_volume: float

# Called when the node enters the scene tree for the first time.
func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_volume_changed)

	# value is a predefined field for this Godot node.
	# It reflects the slider's position. By setting it,
	# we force the slider.
	value = _current_volume()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_volume_changed(delta: float) -> void:
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(delta)
	)

func _current_volume() -> float:
	return db_to_linear(
		AudioServer.get_bus_volume_db(bus_index)
	)
