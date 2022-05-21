extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selected=0
const slot=preload("res://scenes/slot.tscn")
var slots=[]
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(8):
		var temp_slot=slot.instance()
		temp_slot.index=i
		temp_slot.position.x=i*34
		
		temp_slot.connect("input_event", self, "_on_slot_input_event")
		slots.append(temp_slot)
		add_child(temp_slot)
#	print(get_child(selected))
	slots[selected].select()
	
	
	
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_released("wheel_up"):
		selected=get_selected()
		get_child(selected).unselect()
		selected+=1
		if selected >= get_child_count():
			selected=0
		get_child(selected).select()
	elif Input.is_action_just_released("wheel_down"):
		selected=get_selected()
		get_child(selected).unselect()
		selected-=1
		if selected < 0:
			selected=get_child_count()-1
		get_child(selected).select()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
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
