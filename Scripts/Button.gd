extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal pressed

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		$Click.play()
		emit_signal("pressed")
	pass # Replace with function body.
