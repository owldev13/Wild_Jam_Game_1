extends Node2D

var level_constructor
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	level_constructor = get_node("../Camera2D/LevelConstructor")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
	
func _draw():
	if level_constructor.textures.size() == 0:
		return
	for i in range(0, level_constructor.textures.size()):
		draw_texture(level_constructor.textures[i], level_constructor.texture_positions[i])
