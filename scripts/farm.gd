extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# redoooo tilesets rah mkhwrin


var mouse_start_pos
var screen_start_position
var data
var dragging = false

var i=1

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
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
				set_cell($plants,2,data[i].index,i.x,i.y)
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
#				print(generate_atlas_list(tilemap,tilemap.tile_set.find_tile_by_name("orange")))
				var tile_pos = tilemap.world_to_map(pos)
				var cell = tilemap.get_cellv(tile_pos)
				
				if data.has(tile_pos) :
					#add logic if empty and has slot add plant if has plant increase index
					var slot=get_selected_slot()
					if slot.plant !=-1:
						if data[tile_pos].id==Global.EMPTY:
							data[tile_pos].id=Global.plants[slot.plant].id
						
						set_cell($plants,data[tile_pos].id,data[tile_pos].index,tile_pos.x,tile_pos.y)
						data[tile_pos].index+=1
					
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		$Camera2D.position = $Camera2D.zoom * (mouse_start_pos - event.position) + screen_start_position
		

func get_selected_slot():
	var Hudslots=$"UI/Hud slots"
	return Hudslots.slots[Hudslots.selected]
	
func set_cell(tilemap, id,index,x,y):
	tilemap.set_cell(x, y, id, false, false, false, get_subtile_with_priority(id,tilemap,index))

func get_subtile_with_priority(id, tilemap: TileMap,index):
	var tiles = tilemap.tile_set
	var rect = tilemap.tile_set.tile_get_region(id)
	print(id,tiles.autotile_get_size(id))
	var size_x = rect.size.x / tiles.autotile_get_size(id).x
	var size_y = rect.size.y / tiles.autotile_get_size(id).y
	var tile_array = []
	for x in range(size_x):
		for y in range(size_y):
			var priority = tiles.autotile_get_subtile_priority(id, Vector2(x ,y))
			for p in priority:
				tile_array.append(Vector2(x,y))

	return tile_array[index]



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
			set_cell($plants,Global.EMPTY,data[i].index,i.x,i.y)


func _on_test_timeout():
		var tileset=$plants.tile_set
		var ids= tileset.get_tiles_ids()
		print(i)
		set_cell($plants,i,6,10,5)
		i+=1
	 # Replace with function body.
