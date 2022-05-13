extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



var mouse_start_pos
var screen_start_position

var dragging = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
				var pos = get_global_mouse_position()
				var tilemap = $plants
				var tile_pos = tilemap.world_to_map(pos)
				var cell = tilemap.get_cellv(tile_pos)
				if cell>=0:
					cell+=1
					tilemap.set_cell(tile_pos.x,tile_pos.y,cell)
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		
		$Camera2D.position = $Camera2D.zoom * (mouse_start_pos - event.position) + screen_start_position
		
			# if cell == 3: # thetilesets tile id
			#   tilemap.set_cellv(tile_pos, 4)
#			print("TM pos: ", tile_pos)
#			print("cell: ", cell)

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
	if Input.is_action_just_pressed("left_click") and !dragging:
		var pos = get_global_mouse_position()
			
#			print("Mouse Click at: ", pos)
		var tilemap = $plants
		var tile_pos = tilemap.world_to_map(pos)
		var cell = tilemap.get_cellv(tile_pos)
		if cell>=0:
			cell+=1
			tilemap.set_cell(tile_pos.x,tile_pos.y,cell)
