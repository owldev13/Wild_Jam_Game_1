extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum OBJECT_SELECTED{
	none_Selected,
	base_Tile,
	moving_Platform,
	shawblade
}

export(int) var shawblades
export(int) var ground_tiles
export(int) var moving_platforms
var tilemap : TileMap

var drawing_grid : bool

var grid_rect : Rect2

var current_object = OBJECT_SELECTED.none_Selected
# Called when the node enters the scene tree for the first time.

func _ready():
	for child in self.get_children():
		if child.name == "Shawblade" && shawblades == 0:
			child.queue_free()
		if child.name == "Moving_Platform" && moving_platforms == 0:
			child.queue_free()
		if child.name == "Ground" && ground_tiles == 0:
			child.queue_free()
	tilemap = get_parent().get_node("TileMap")
	drawing_grid = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_object != OBJECT_SELECTED.none_Selected:
		var mouse_pos = tilemap.to_local(get_global_mouse_position())
		var map_position = tilemap.world_to_map(mouse_pos)
		grid_rect = Rect2(tilemap.to_global(tilemap.map_to_world(map_position)), Vector2(32,32))
		if tilemap.get_cell(map_position.x, map_position.y) == -1:
			drawing_grid = true
		else:
			drawing_grid = false


func _on_Ground_pressed():
	if ground_tiles:
		current_object = OBJECT_SELECTED.base_Tile
		print("Current object is tile")


func _on_Moving_Platform_pressed():
	if moving_platforms:
		current_object = OBJECT_SELECTED.moving_Platform
		print("Current object is moving platform")


func _on_Shawblade_pressed():
	if shawblades:
		current_object = OBJECT_SELECTED.shawblade
		print("Current object is moving platform")
