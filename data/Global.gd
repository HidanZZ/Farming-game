extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var data
const EMPTY=0
# Replace with function body.

var plants := {
	0:{
		"name":"beatroot",
		"id":1,
		"time":60
	},1:{
		"name":"Plant 2",
		"id":2,
		"time":60
	},2:{
		"name":"Plant 3",
		"id":3,
		"time":60
	},3:{
		"name":"Plant 4",
		"id":4,
		"time":60
	},4:{
		"name":"Plant 5",
		"id":5,
		"time":60
	},5:{
		"name":"Plant 6",
		"id":6,
		"time":60
	}
	
}
func find_plant_by_id(id):
	for i in plants.values():
		if i.id==id:
			return i

func _ready():
	data = SaveLoad.load_settings()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
