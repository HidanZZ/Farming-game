extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



var mouse_start_pos
var screen_start_position
var data
var dragging = false

var i=0

# Called when the node enters the scene tree for the first time.
func _ready():
	data = SaveLoad.load_settings()
	if !data:
		var used_cell=$plants.get_used_cells()
		data={}
		
		for i in used_cell:
			data[i]={"index":0,"id":Global.EMPTY}
	else:
		print($plants.get_used_cells())
		for i in data:
			if data[i].id!=Global.EMPTY:
				place_atlas_tile($plants,2,data[i].index,i.x,i.y)
	 # Replace with function body.
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		SaveLoad.save_settings(data)
		
		
func _input(event):
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position =  $Camera2D.position
			dragging = true
		else:
			if mouse_start_pos==event.position && event.button_index == BUTTON_LEFT:
				
				var pos = get_global_mouse_position()
				var tilemap = $plants
					
				var tile_pos = tilemap.world_to_map(pos)
				var cell = tilemap.get_cellv(tile_pos)
				
				if data.has(tile_pos) :
					#add logic if empty and has slot add plant if has plant increase index
					var slot=get_selected_slot()
					if slot.plant !=-1:
						if data[tile_pos].id==Global.EMPTY:
							data[tile_pos].id=Global.plants[slot.plant].id
						
						print(data[tile_pos])
#						place_atlas_tile($plants,6,4,tile_pos.x,tile_pos.y)
						tilemap.set_cell(tile_pos.x,tile_pos.y,-1,false,false,false,Vector2(6,1))
						data[tile_pos].index+=1
#					tilemap.set_cell(tile_pos.x,tile_pos.y,cell)
					
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		$Camera2D.position = $Camera2D.zoom * (mouse_start_pos - event.position) + screen_start_position
		

func get_selected_slot():
	var Hudslots=$"UI/Hud slots"
	return Hudslots.slots[Hudslots.selected]
	
	
func place_atlas_tile(tilemap : TileMap, tileset_atlas_index : int, index:int, x : int, y : int) -> void:
	var atlas_list = generate_atlas_list(tilemap, tileset_atlas_index)
	print(atlas_list)
	var autotile_coord = atlas_list[index]
	
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
#	print(tileset.get_tiles_ids())
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


func _on_clear_pressed():
	for i in $plants.get_used_cells():
			data[i]={"index":0,"id":Global.EMPTY}
			place_atlas_tile($plants,1,data[i].index,i.x,i.y)


func _on_test_timeout():
		var tileset=$plants.tile_set
		var ids= tileset.get_tiles_ids()
		place_atlas_tile($plants,i,0,10,5)
		i+=1
	 # Replace with function body.
