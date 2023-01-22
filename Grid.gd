extends Node2D

var level_constructor

func _ready():
	level_constructor = get_parent().get_node("Camera2D/LevelConstructor")

func _draw():
	if level_constructor.drawing_grid:
		draw_rect(level_constructor.grid_rect, Color(1,0,0), false, 2.0)
		draw_texture(level_constructor.current_texture, level_constructor.grid_rect.position)
		
		
func _process(_delta):
	update()
