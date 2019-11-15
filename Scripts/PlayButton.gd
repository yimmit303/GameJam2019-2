extends Label

var focused

func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed or Input.is_key_pressed(KEY_ENTER):
		if focused:
			var character_tween = get_node("../../Tween")
			character_tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			character_tween.interpolate_property(get_node("../Exit"), "modulate", Color(1,1,1,1), Color(1,1,1,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			character_tween.interpolate_property(get_node("../Title"), "modulate", Color(1,1,1,1), Color(1,1,1,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			character_tween.interpolate_property(get_node("../../Character"), "scale", Vector2(40,40), Vector2(1,1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			character_tween.interpolate_property(get_node("../ColorRect"), "modulate", Color(1,1,1,1), Color(1,1,1,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			get_node("../../Start").play()
			character_tween.start()
			yield(character_tween, "tween_all_completed")
			get_node("../ColorRect").visible = false
			get_node("../Exit").queue_free()
			get_node("../..").control = true
			Globals.just_started = false
			self.queue_free()
			
func _on_Play_mouse_entered():
	get_node("../../Menu_Mouseover").play()
	var style = self.get_stylebox("normal")
	style.bg_color = Color(0.6,0.6,0.6,0.7)
	focused = true


func _on_Play_mouse_exited():
	var style = self.get_stylebox("normal")
	style.bg_color = Color(0.6,0.6,0.6,0.125)
	focused = false
