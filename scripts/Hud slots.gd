extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selected=0
const slot=preload("res://scenes/slot.tscn")
var slots=[]
var title
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for i in range(8):
		var temp_slot=slot.instance()
		temp_slot.index=i
		temp_slot.position.x=i*34
		
		temp_slot.connect("input_event", self, "_on_slot_input_event")
		slots.append(temp_slot)
		$slots.add_child(temp_slot)
#	print(get_child(selected))
	make_title()
	slots[selected].select()
	
	
func make_title():
	title = Label.new()
	title.text="empty"
	title.rect_position.y+=20
	title.rect_position.x=125-(title.rect_size.x/2)
	add_child(title)
	
func _process(delta):
	if Input.is_action_just_released("wheel_up"):
		selected=get_selected()
		slots[selected].unselect()
		selected+=1
		if selected >= slots.size():
			selected=0
		slots[selected].select()
	elif Input.is_action_just_released("wheel_down"):
		selected=get_selected()
		slots[selected].unselect()
		selected-=1
		if selected < 0:
			selected=slots.size()-1
		slots[selected].select()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func change_title(text):
	title.text=text
	title.rect_position.x=125-(title.rect_size.x/2)
func get_selected():
	for i in slots.size():
		if slots[i].selected:
			return i

func _on_slot_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton  and event.button_index == BUTTON_LEFT and event.pressed:
		print(shape_idx)
		for i in get_children():
#			pass
			if i.selected:
				i.unselect()


func _on_random_pressed():
	var plants = Global.plants
	var plant_index= randi()%(plants.size()-1)
	var random_plant=plants[plant_index]
	print(random_plant.id)
	slots[get_selected()].add_plant(plant_index)
	change_title(random_plant.name)
	
