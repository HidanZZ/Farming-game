extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selected=0

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(get_child_count()):
		get_child(i).position.x=i*34
	get_child(selected).position.y-=10
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_released("wheel_up"):
		print('sss')
		get_child(selected).position.y+=10
		selected+=1
		if selected >= get_child_count():
			selected=0
		get_child(selected).position.y-=10
	elif Input.is_action_just_released("wheel_down"):
		get_child(selected).position.y+=10
		selected-=1
		if selected < 0:
			selected=get_child_count()-1
		get_child(selected).position.y-=10
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
