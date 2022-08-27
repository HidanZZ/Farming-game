extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var tilemap = get_parent().get_parent().get_parent().get_parent().get_node("plants")
var selected = false
var plant = -1
var index
var icon
var q_label
var q=0
# Called when the node enters the scene tree for the first time.
func _ready():
	init_icon(1)
func is_empty():
	return plant ==-1
func is_plant(plant):
	return self.plant==plant
func init_icon(qs):
	if plant in range(Global.plants.size()):
		q+=qs
		var tileset=tilemap.tile_set
		var region_rect=tileset.tile_get_region(Global.plants[plant].id)
		region_rect.position.x+= tilemap.cell_size.x*6
		icon = Sprite.new()
		icon.texture=tileset.tile_get_texture(1)
		icon.region_enabled=true
		icon.centered=false
		icon.region_rect= Rect2(region_rect.position,tilemap.cell_size)
		add_child(icon)
		q_label=Label.new()
		q_label.text=str(q)
		q_label.set_position(Vector2(15,5))
		add_child(q_label)
		
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
func incerement(q):
	self.q+=q
	q_label.text=str(self.q)
func decrement():
	q-=1
	q_label.text=str(q)
	if q == 0 :
		delete_plant()
func delete_plant():
	icon.queue_free()
	q_label.queue_free()
	icon=null
	q_label=null
	plant=-1
	
func add_plant(plant_id,q):
	plant=plant_id
	if icon:
		incerement(q)
	else:
		init_icon(q)
	

func _on_slot_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton  and event.button_index == BUTTON_LEFT and event.pressed:
		if !selected:
			select() # Replace with function body.
