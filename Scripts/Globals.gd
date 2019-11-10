extends Node

# Declare member variables here. Examples:
# var a = 2

var just_started

# Called when the node enters the scene tree for the first time.
func _ready():
	just_started = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
