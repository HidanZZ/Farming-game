extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



var mouse_start_pos
var screen_start_position
var data
var dragging = false



# Called when the node enters the scene tree for the first time.
func _ready():
	data = SaveLoad.load_settings()
	if !data:
		var used_cell=$plants.get_used_cells()
		data={}
		for i in used_cell:
			data[i]={"index":0}
	else:
		for i in data:
			if data[i].index!=0:
				place_atlas_tile($plants,2,data[i].index,i.x,i.y)
	 # Replace with function body.
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		SaveLoad.save_settings(data)
		
		
func _input(event):
	
	if event is InputEventMouseButton:
		if event.is_pressed():
#			print(screen_start_position==event.position)
#			print(screen_start_position==event.position)
			mouse_start_pos = event.position
			screen_start_position =  $Camera2D.position
			dragging = true
		else:
			if mouse_start_pos==event.position:
#				var file = File.new()
#				file.open("res://data/data.json", file.READ_WRITE)
#				var json = file.get_as_text()
#				var json_result = JSON.parse(json).result
#				print(json_result)
				var pos = get_global_mouse_position()
				var tilemap = $plants
#				var used_cell=tilemap.get_used_cells()
#				var data={}
#				for i in used_cell:
#					data[i]={"index":0}
					
				print(data[Vector2(10,6)])
				var tile_pos = tilemap.world_to_map(pos)
				var cell = tilemap.get_cellv(tile_pos)
				if data[tile_pos].index>=0:
					data[tile_pos].index+=1
					place_atlas_tile($plants,2,data[tile_pos].index,tile_pos.x,tile_pos.y)
#					tilemap.set_cell(tile_pos.x,tile_pos.y,cell)
					
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		
		$Camera2D.position = $Camera2D.zoom * (mouse_start_pos - event.position) + screen_start_position
		
			# if cell == 3: # thetilesets tile id
			#   tilemap.set_cellv(tile_pos, 4)
#			print("TM pos: ", tile_pos)
#			print("cell: ", cell)
func place_atlas_tile(tilemap : TileMap, tileset_atlas_index : int, index:int, x : int, y : int) -> void:
	var atlas_list = generate_atlas_list(tilemap, tileset_atlas_index)
	var autotile_coord = atlas_list[index]
	print(index)
	tilemap.set_cell(
		x,
		y,
		tileset_atlas_index,
		false,
		false,
		false,
		autotile_coord)

func generate_atlas_list(tilemap : TileMap, tileset_atlas_index : int) -> Array:
	var cell_size = tilemap.cell_size
	var array = Array()
	var tileset : TileSet = tilemap.tile_set
	var region = tileset.tile_get_region(tileset_atlas_index)
	var start = region.position / cell_size
	var end = region.end / cell_size
	for x in range(start.x, end.x):
		for y in range(start.y, end.y):
			var autotile_coord = Vector2(x, y)
			var priority = tileset.autotile_get_subtile_priority(tileset_atlas_index, autotile_coord)
			for p in priority:
				array.append(autotile_coord)
	return array
#			print("Mouse Unclick at: ", pos)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _unhandled_input(event: InputEvent) -> void:
#	print(event.g)
	var mouse_pos = get_global_mouse_position()
	var tile_pos = $plants.world_to_map(mouse_pos)
	var tile_cell_at_mouse_pos = $plants.get_cellv(tile_pos)
	if tile_cell_at_mouse_pos != -1:
		$Cursor.global_position=$plants.map_to_world(tile_pos)
		$Cursor.visible=true
	else:
		$Cursor.visible=false
func _process(delta):
	pass
#	if Input.is_action_just_pressed("left_click") and !dragging:
#		var pos = get_global_mouse_position()
#
##			print("Mouse Click at: ", pos)
#		var tilemap = $plants
#		var tile_pos = tilemap.world_to_map(pos)
#		var cell = tilemap.get_cellv(tile_pos)
#		if cell>=0:
#			cell+=1
#			tilemap.set_cell(tile_pos.x,tile_pos.y,cell)
