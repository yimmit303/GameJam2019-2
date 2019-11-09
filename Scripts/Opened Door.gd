extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	var child = get_node("StaticBody2D/CollisionShape2D")
	child.disabled = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func open():
	self.visible = true
	var child = get_node("StaticBody2D/CollisionShape2D")
	child.disabled = false