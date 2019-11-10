extends Label


var focused

func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if focused:
			get_tree().quit()


func _on_Exit_mouse_entered():
	focused = true


func _on_Exit_mouse_exited():
	focused = false
