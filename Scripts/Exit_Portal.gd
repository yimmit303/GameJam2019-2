extends Node2D

signal exited

export var next_level = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var children = get_children()
	var dir = 1
	for child in children:
		child.rotate(1 * delta * dir)
		dir *= -1

func _on_Area2D_body_entered(body):
	get_parent().get_node("Player").do_exit_animation()
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene("Scenes/" + next_level + ".tscn")
