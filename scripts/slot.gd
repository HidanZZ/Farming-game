extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var tilemap = get_parent().get_parent().get_parent().get_node("plants")
var selected = false
var plant = -1
var index
var icon
# Called when the node enters the scene tree for the first time.
func _ready():
	init_icon()

func init_icon():
	if plant in range(Global.plants.size()):
		var tileset=tilemap.tile_set
		var region_rect=tileset.tile_get_region(Global.plants[plant].id)
		region_rect.position.x+= tilemap.cell_size.x*6
		icon = Sprite.new()
		icon.texture=tileset.tile_get_texture(1)
		icon.region_enabled=true
		icon.centered=false
		icon.region_rect= Rect2(region_rect.position,tilemap.cell_size)
		add_child(icon)
		
func change_icon():
	if plant in range(Global.plants.size()):
		var tileset=tilemap.tile_set
		var region_rect=tileset.tile_get_region(Global.plants[plant].id)
		region_rect.position.x+= tilemap.cell_size.x*6
		
		
		icon.region_rect= Rect2(region_rect.position,tilemap.cell_size)
	else:
		icon.texture=null
# Called every frame. 'delta' is the elapsed time since the previous frame.
func unselect():
	self.position.y+=10
	selected=false
func select():
	self.position.y-=10
	selected=true



func _on_slot_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton  and event.button_index == BUTTON_LEFT and event.pressed:
		if !selected:
			select() # Replace with function body.
