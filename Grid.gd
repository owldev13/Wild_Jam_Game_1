extends Node2D


func _draw():
	var level_constructor = get_parent().get_node("LevelConstructor")
	if level_constructor.drawing_grid:
		draw_rect(level_constructor.grid_rect, Color(1,0,0), false)
	print("Drawing grid")

func _process(_delta):
	update()
