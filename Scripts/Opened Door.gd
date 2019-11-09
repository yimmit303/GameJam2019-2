extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var sBody
var cRect
var pos

# Called when the node enters the scene tree for the first time.
func _ready():
	sBody = get_node("StaticBody2D/CollisionShape2D")
	cRect = get_node("StaticBody2D/ColorRect")
	pos = self.position
	self.position = Vector2(1000000000,1000000000)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func open():
	self.position = pos
	pass