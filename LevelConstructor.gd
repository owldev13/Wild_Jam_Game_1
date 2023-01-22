extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum OBJECT_SELECTED{
	none_Selected,
	base_Tile,
	moving_Platform,
	ramp
}

export(int) var ramps
export(int) var ground_tiles
export(int) var moving_platforms

var is_flipped = false

var tilemap : TileMap

var placeable_tilemap_positions : TileMap

var drawing_grid : bool

var grid_rect : Rect2

var can_place_moving_platform = true

var current_object = OBJECT_SELECTED.none_Selected

var block_instance : PackedScene

var ramp_instance : PackedScene

var moving_platform_instance : PackedScene

var platform_texture

var ramp_texture

var flipped_ramp_texture

var block_texture

var nodes : Array

var textures: Array

var texture_positions : Array

var current_texture
# Called when the node enters the scene tree for the first time.

func _ready():
	
	get_node("Ground").text = "You have: " + str(ground_tiles)
	
	get_node("Moving_Platform").text = "You have: " + str(moving_platforms)
	
	get_node("Ramp").text = "You have: " + str(ramps)
	
	for child in self.get_children():
		if child.name == "Ramp" && ramps == 0:
			child.queue_free()
		if child.name == "Moving_Platform" && moving_platforms == 0:
			child.queue_free()
		if child.name == "Ground" && ground_tiles == 0:
			child.queue_free()
	tilemap = get_parent().get_parent().get_node("BasePlatforms")
	drawing_grid = false
	platform_texture = load("res://Moving_Platform3.png")
	block_texture = load("res://Crate.png")
	ramp_texture = load("res://Ramp.png")
	flipped_ramp_texture = load("res://FlippedRamp.png")
	block_instance = load("res://Block.tscn")
	ramp_instance = load("res://Ramp.tscn")
	moving_platform_instance = load("res://MovingPlatform.tscn")

func place_block(tilemap_coords : Vector2):
	if ground_tiles != 0:
		var block_node = block_instance.instance()
		
		block_node.position = tilemap.to_global(tilemap.map_to_world(tilemap_coords)) + Vector2(16,16)
		
		nodes.append(block_node)
		textures.append(block_texture)
		texture_positions.append(grid_rect.position)
		ground_tiles -= 1
		get_node("Ground").text = "You have: " + str(ground_tiles)

	
func place_moving_platform():
	if moving_platforms != 0:
		var platform_node = moving_platform_instance.instance()
		platform_node.position = grid_rect.position + Vector2(48, 8)
		
		nodes.append(platform_node)
		textures.append(platform_texture)
		texture_positions.append(grid_rect.position)
		moving_platforms -= 1
		get_node("Moving_Platform").text = "You have: " + str(moving_platforms)
	
func place_ramp(tilemap_coords : Vector2):
	if ramps != 0:
		var ramp_node = ramp_instance.instance()
		
		ramp_node.position = tilemap.to_global(tilemap.map_to_world(tilemap_coords)) + Vector2(16,16)
		
		if is_flipped:
			ramp_node.scale.x = -1
			textures.append(flipped_ramp_texture)

		
		nodes.append(ramp_node)
		if !is_flipped:
			textures.append(ramp_texture)
		texture_positions.append(grid_rect.position)
		ramps -= 1
		get_node("Ramp").text = "You have: " + str(ramps)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("flip"):
		is_flipped = !is_flipped
	drawing_grid = false
	if current_object != OBJECT_SELECTED.none_Selected:
		var mouse_pos = tilemap.to_local(get_global_mouse_position())
		
		match current_object:
			
			OBJECT_SELECTED.base_Tile:
				is_flipped = false
				current_texture = block_texture
				var map_position = tilemap.world_to_map(mouse_pos)
				grid_rect = Rect2(tilemap.to_global(tilemap.map_to_world(map_position)), Vector2(32,32))
				if tilemap.get_cell(map_position.x, map_position.y) == -1 && !self.get_global_rect().intersects(grid_rect) && ground_tiles:
					drawing_grid = true
					if Input.is_action_just_pressed("click"):
						place_block(map_position)
				else:
					drawing_grid = false
					
			OBJECT_SELECTED.moving_Platform:
				is_flipped = false
				current_texture = platform_texture
				var map_position = tilemap.world_to_map(mouse_pos - Vector2(32,0))
				grid_rect = Rect2(tilemap.to_global(tilemap.map_to_world(map_position)), Vector2(96,128))
				can_place_moving_platform = true
				for i in range (0,3,1):
					for a in range(0,4,1):
						if tilemap.get_cell(map_position.x + i, map_position.y + a) != -1:
							can_place_moving_platform = false
				if moving_platforms == 0:
					can_place_moving_platform = false
				if can_place_moving_platform && !self.get_global_rect().intersects(grid_rect):
					drawing_grid = true
					if Input.is_action_just_pressed("click") && !self.get_global_rect().intersects(grid_rect):
						place_moving_platform()
				if !can_place_moving_platform:
					drawing_grid = false
					
			OBJECT_SELECTED.ramp:
				if is_flipped:
					current_texture = flipped_ramp_texture
				else:
					current_texture = ramp_texture
				var map_position = tilemap.world_to_map(mouse_pos)
				grid_rect = Rect2(tilemap.to_global(tilemap.map_to_world(map_position)), Vector2(32,32))
				if tilemap.get_cell(map_position.x, map_position.y) == -1 && !self.get_global_rect().intersects(grid_rect) && ramps:
					drawing_grid = true
					if Input.is_action_just_pressed("click"):
						place_ramp(map_position)
				else:
					drawing_grid = false
					
	if Input.is_action_just_pressed("start"):
		for node in nodes:
			get_tree().get_root().add_child(node)
		nodes.clear()
		textures.clear()
		texture_positions.clear()
		current_object = OBJECT_SELECTED.none_Selected
		get_node("../../Grid").queue_free()
		get_node("../../Textures").queue_free()
		get_node(".").queue_free()


func _on_Ground_pressed():
	if !ground_tiles:
		current_object = OBJECT_SELECTED.none_Selected
	if ground_tiles:
		if current_object != OBJECT_SELECTED.base_Tile:
			current_object = OBJECT_SELECTED.base_Tile
		else: 
			current_object = OBJECT_SELECTED.none_Selected
		drawing_grid = false


func _on_Moving_Platform_pressed():
	if !moving_platforms:
		current_object = OBJECT_SELECTED.none_Selected
	if moving_platforms:
		if current_object != OBJECT_SELECTED.moving_Platform:
			current_object = OBJECT_SELECTED.moving_Platform
		else: 
			current_object = OBJECT_SELECTED.none_Selected
		drawing_grid = false
	

func _on_Shawblade_pressed():
	if !ramps:
		current_object = OBJECT_SELECTED.none_Selected
	if ramps:
		if current_object != OBJECT_SELECTED.ramp:
			current_object = OBJECT_SELECTED.ramp
		else: current_object = OBJECT_SELECTED.none_Selected
		drawing_grid = false
