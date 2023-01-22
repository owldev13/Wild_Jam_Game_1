extends Camera2D

var is_player_in_scene

var player_node
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _unhandled_input(event):
	if !is_player_in_scene:
		if event is InputEventMouseMotion:
			if event.button_mask == BUTTON_MASK_MIDDLE:
				position -= event.relative * zoom

# Called when the node enters the scene tree for the first time.
func _ready():
	anchor_mode = ANCHOR_MODE_DRAG_CENTER
	current = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_player_in_scene:
		if get_tree().get_root().has_node("PlayerCharacter"):
			is_player_in_scene = true
			player_node = get_tree().get_root().get_node("PlayerCharacter")
	if is_player_in_scene:
		position = player_node.position - offset
