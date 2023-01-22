extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var starting_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	starting_position = position
# Replace with function body.

func _process(delta):
	position.y = sin(Time.get_unix_time_from_system()) * 2 + starting_position.y
	for i in get_node("Area2D").get_overlapping_bodies():
		if i.name == "PlayerCharacter":
			i.key_unlocked = true
			self.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
