extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.window_position = Vector2(0,0)
	pass # Replace with function body.

func _draw():
	for walk_list in get_node("Player").points_list_list:
		self.draw_polyline_colors(walk_list, get_node("Player").walk_color, 3)
		for point in walk_list:
			self.draw_circle(point, 5, Color(0,0,0,1))

func add_area(added, prev_node):
	var area = Area2D.new()
	var new_collision = CollisionShape2D.new()
	var shape = SegmentShape2D.new()
	shape.a = added
	shape.b = prev_node
	new_collision.shape = shape
	self.add_child(area)
	area.add_child(new_collision)
	#area.connect("area_entered", get_node("Player"), "on_line_touch")