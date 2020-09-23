extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var sBody
var cRect
var pos

# Called when the node enters the scene tree for the first time.
func _ready():
	sBody = get_node("StaticBody2D")
	cRect = get_node("ColorRect")
	pos = sBody.position
	sBody.position = Vector2(1000000000,1000000000)

func close():
	sBody.position = pos
	cRect.color = Color(.5,1,.5, 1)

func _draw():
	draw_rect(cRect.get_rect(), Color(.5,1,.5,.5), false)
