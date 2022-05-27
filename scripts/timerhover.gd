extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var label=$timer
var timer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_text(text):
	label.text=text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer:
		set_text(format_time(timer.get_time_left()))

func format_time(time, digit_format = "%02d"):
	var digits = []
	
	var hours = digit_format % [time / 3600]
	digits.append(hours)
	
	var minutes = digit_format % [time / 60]
	digits.append(minutes)
	
	var seconds = digit_format % [int(ceil(time)) % 60]
	digits.append(seconds)
	
	var formatted = String()
	var colon = " : "
	for digit in digits:
		formatted += digit + colon
	if not formatted.empty():
		formatted = formatted.rstrip(colon)
	return formatted
