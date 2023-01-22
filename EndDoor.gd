extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(String) var next_level

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in get_node("Area2D").get_overlapping_bodies():
		if i.name =="PlayerCharacter":
			if i.key_unlocked:
				get_tree().call_group("User added blocks", "queue_free")
				get_tree().change_scene(next_level)
