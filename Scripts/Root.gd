extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.window_position = Vector2(0,0)
	pass # Replace with function body.

func _draw():
	self.draw_polyline(get_node("Player").walk_points, Color(1,0,0,1))
