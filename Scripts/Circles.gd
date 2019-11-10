extends Node2D

# Declare member variables here. Examples:
var circle_pos = []
var circle_sizes = []
var circle_color = Color(1,1,1,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	draw_circle(Vector2(0,0), 20, Color(1,1,1,1))
