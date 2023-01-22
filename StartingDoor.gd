extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player_character_instance

var has_spawned_player = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player_character_instance = load("res://PlayerCharacter.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("start") && !has_spawned_player:
		var player_node = player_character_instance.instance()
		player_node.position = self.position
		get_tree().get_root().add_child(player_node)
		has_spawned_player = true
		pass
