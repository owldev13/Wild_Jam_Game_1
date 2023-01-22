extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var start_position : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	start_position = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y = sin(Time.get_unix_time_from_system()) * 2 + start_position.y 
