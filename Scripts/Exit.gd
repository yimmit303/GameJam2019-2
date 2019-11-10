extends Label


var focused

func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if focused:
			get_tree().quit()


func _on_Exit_mouse_entered():
	get_node("../../Menu_Mouseover").play()
	var style = self.get_stylebox("normal")
	style.bg_color = Color(0.6,0.6,0.6,0.7)
	focused = true


func _on_Exit_mouse_exited():
	var style = self.get_stylebox("normal")
	style.bg_color = Color(0.6,0.6,0.6,0.125)
	focused = false
