extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var anima := Anima.begin(self)
# redoooo tilesets rah mkhwrin

var shop_open=false;
var mouse_start_pos
var screen_start_position
var dragging = false

var i=1

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var used_cell=$plants.get_used_cells()
	Global.data={}

	for i in used_cell:
		Global.data[i]={"index":0,"id":Global.EMPTY}
	 # Replace with function body.
func load_data_to_game():
	for i in Global.data:
			if Global.data[i].id!=Global.EMPTY:
				set_cell($plants,Global.data[i].id,Global.data[i].index,i.x,i.y)
				Global.data[i].timer.wait_time=Global.data[i].time_remaining
				Global.data[i].timer.autostart=true
				add_child(Global.data[i].timer)
				
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		save_time_remaining()
		SaveLoad.save_settings(Global.data)
		
func save_time_remaining():
	for i in Global.data:
		if Global.data[i].id!=Global.EMPTY:
			Global.data[i].time_remaining=Global.data[i].timer.get_time_left()
func _input(event):
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position =  $Camera2D.position
			dragging = true
		else:
			if mouse_start_pos==event.position && event.button_index == BUTTON_LEFT:
				
				var pos = get_global_mouse_position()
				place_plant(pos)
					
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		$Camera2D.position = $Camera2D.zoom * (mouse_start_pos - event.position) + screen_start_position
		
func place_plant(pos):
	var tilemap = $plants
#				print(generate_atlas_list(tilemap,tilemap.tile_set.find_tile_by_name("orange")))
	var tile_pos = tilemap.world_to_map(pos)
	var cell = tilemap.get_cellv(tile_pos)
				
	if Global.data.has(tile_pos) :
					#add logic if empty and has slot add plant if has plant increase index
		var slot=get_selected_slot()
		if slot.plant !=-1:
			if Global.data[tile_pos].id==Global.EMPTY:
				Global.data[tile_pos].id=Global.plants[slot.plant].id
				set_cell($plants,Global.data[tile_pos].id,Global.data[tile_pos].index,tile_pos.x,tile_pos.y)
				var timer=setup_timer(Global.plants[slot.plant].time)
				Global.data[tile_pos].timer=timer
				add_child(timer)
				slot.decrement()
		if Global.data[tile_pos].index==5:
					$"UI/Hud slots".add_plant_to_slot(Global.find_plant_i_by_id(Global.data[tile_pos].id),randi()%10+1)
					Global.data[tile_pos]={"index":0,"id":Global.EMPTY}
					set_cell($plants,Global.EMPTY,Global.data[tile_pos].index,tile_pos.x,tile_pos.y)
				
					
				
	
#				Global.data[tile_pos].index+=1
func setup_timer(time):
	var timer= Timer.new()
	timer.one_shot=true
	timer.wait_time=time
	timer.autostart=true
	return timer
func get_selected_slot():
	var Hudslots=$"UI/Hud slots"
	return Hudslots.slots[Hudslots.selected]
	
func set_cell(tilemap, id,index,x,y):
	tilemap.set_cell(x, y, id, false, false, false, get_subtile_with_priority(id,tilemap,index))

func get_subtile_with_priority(id, tilemap: TileMap,index):
	var tiles = tilemap.tile_set
	var rect = tilemap.tile_set.tile_get_region(id)
#	print(id,tiles.autotile_get_size(id))
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
		
		show_timer_ui(tile_pos,mouse_pos)
		$Cursor.global_position=$plants.map_to_world(tile_pos)
		$Cursor.visible=true
	else:
		$Cursor.visible=false
		$"UI/timer hover".visible=false
		
func show_timer_ui(tile_pos,mouse_pos):
	var timer_ui=$"UI/timer hover"
	
	var spot=Global.data[tile_pos]
	if spot.id!=Global.EMPTY:
		if spot.timer:
			timer_ui.timer=spot.timer
			timer_ui.visible=true
#			timer_ui.position=$plants.map_to_world(tile_pos)
			timer_ui.position=get_viewport().get_mouse_position()
	else:
		timer_ui.visible=false

func _process(delta):
	for i in Global.data:
		var planted=Global.data[i]
		if planted.id!=Global.EMPTY:
			if planted.timer:
#				print(planted.timer.get_time_left())
#				print(60 - (60*(planted.index+1)/5))
				var duration= Global.find_plant_by_id(planted.id).time
				if planted.timer.get_time_left()<=duration - (duration/5)*(planted.index+1):
					Global.data[i].index+=1
					set_cell($plants,Global.data[i].id,Global.data[i].index,i.x,i.y)
					
					
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
			Global.data[i]={"index":0,"id":Global.EMPTY}
			set_cell($plants,Global.EMPTY,Global.data[i].index,i.x,i.y)


#func _on_test_timeout():
#		var tileset=$plants.tile_set
#		var ids= tileset.get_tiles_ids()
#		print(i)
#		set_cell($plants,i,6,10,5)
#		i+=1
	 # Replace with function body.


func _on_hide_pressed():
	$UI/clear.visible=false
	$UI/random.visible=false
	$UI/hide.visible=false
	pass # Replace with function body.


func _on_shop_open_shop():
	$UI/shop_ui/AnimationPlayer.playback_speed=5
	if shop_open:
		$UI/shop_ui/AnimationPlayer.play_backwards("enter")
	else:
		
		$UI/shop_ui/AnimationPlayer.play("enter")




func _on_shop_animation_finished(anim_name):
	shop_open=!shop_open# Replace with function body.
