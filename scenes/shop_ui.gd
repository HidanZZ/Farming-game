extends Node2D

onready var tilemap = get_parent().get_parent().get_node("plants")
# Declare member variables here. Examples:
# var a = 2
# var b = "tev
const buy=preload("res://scenes/buyButton.tscn")
#const coin=preload("res://scenes/coin.tscn")
signal buy_item
# Called when the node enters the scene tree for the first time.
func _ready():
	for plant in range(Global.plants.size()):
		var tileset=tilemap.tile_set
		var region_rect=tileset.tile_get_region(Global.plants[plant].id)
		region_rect.position.x+= tilemap.cell_size.x*6
		var icon = Sprite.new()
		icon.texture=tileset.tile_get_texture(1)
		icon.region_enabled=true
		icon.scale=Vector2(3,3)
		icon.position=Vector2(tilemap.cell_size.x*3*(plant)+30,50)
		icon.centered=false
		icon.region_rect= Rect2(region_rect.position,tilemap.cell_size)
		add_child(icon)
		var price = randi() % 500 + 200
		var price_label= Label.new()
		price_label.text=str(price)
		price_label.set_position(Vector2(tilemap.cell_size.x*3*(plant)+45,100)) # Replace with function body.
		add_child(price_label)
		var name= Label.new()
		name.text=Global.plants[plant].name
		name.set_position(Vector2(tilemap.cell_size.x*3.1*(plant)+35,30)) # Replace with function body.
		add_child(name)
		var button = buy.instance()
		button.plant_id=plant
		button.price=price
		button.connect("buy",self,"_on_buy")
		button.position=Vector2(tilemap.cell_size.x*3*(plant)+35,120)
		add_child(button)
		

func _on_buy(plant_id,price):
	emit_signal("buy_item",plant_id,price)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
