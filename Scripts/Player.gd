extends KinematicBody2D

var vel = Vector2(0,0)
var max_speed = 400
var up = Vector2(0, -1)

var ACCEL = 4
var DEACCEL = 8
var GRAVITY = 1800
var JUMP_MULT = 2.5
var LOW_JUMP_MULT = 2

var distance_moved = 64
var walk_points = PoolVector2Array()
var walk_color = PoolColorArray()
var points_list_list = []
var color_list_list = []
var last_point

var charge_num = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	last_point = self.global_position
	walk_points.append(self.global_position)
	walk_points.append(self.global_position)
	walk_color.append(Color(1,0,0,1))
	walk_color.append(Color(1,0,0,1))

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if self.global_position.distance_to(last_point) >= distance_moved:
		walk_points.append(self.global_position)
		
		for i in range(walk_color.size()):
			if walk_color[i].b != 1:
				walk_color[i].r -= 0.05
				walk_color[i].b += 0.05
		
		for color_list in color_list_list:
			for i in range(color_list.size()):
				if color_list[i].b != 1:
					color_list[i].r -= 0.05
					color_list[i].b += 0.05
		
		walk_color.append(Color(1,0,0,1))
		last_point = walk_points[walk_points.size() - 1]
		get_parent().update()
		if walk_points.size() >= 3:
			get_parent().add_area(walk_points[walk_points.size() - 3], walk_points[walk_points.size() - 2])
	
	var dir = Vector2(0,0)
	self.max_speed = 800
	
	if Input.is_key_pressed(KEY_D):
		dir.x += 1
	if Input.is_key_pressed(KEY_A):
		dir.x -= 1
	if Input.is_key_pressed(KEY_SPACE) and self.is_on_floor():
		self.vel.y = -2000
	if Input.is_key_pressed(KEY_SHIFT):
		self.max_speed = 800

	#animation
#	if Input.is_key_pressed(KEY_D):
#		self.get_node("AnimatedSprite").flip_h = false
#		self.get_node("AnimatedSprite").play("Walking")
#	elif Input.is_key_pressed(KEY_A):
#		self.get_node("AnimatedSprite").flip_h = true
#		self.get_node("AnimatedSprite").play("Walking")
#	elif Input.is_key_pressed(KEY_SPACE):
#		self.get_node("AnimatedSprite").play("Jump")
#	else:
#		self.get_node("AnimatedSprite").play("Idle")
	dir = dir.normalized()
	
	var hvel = self.vel
	hvel.y = 0
	
	var target = dir * self.max_speed

	
	var accel
	
	if (dir.dot(hvel) > 0):
		accel = self.ACCEL
	else:
		accel = self.DEACCEL
		
	hvel = hvel.linear_interpolate(target, accel*delta)
	self.vel.x = hvel.x
	
	# Jumping
	if not self.is_on_floor():
		if (self.vel.y < 0 and !Input.is_action_pressed("Jump")):
			self.vel.y += self.GRAVITY * (self.JUMP_MULT - 1) * delta
		elif (self.vel.y <= 0 and Input.is_action_pressed("Jump")):
			self.vel.y += self.GRAVITY * (self.LOW_JUMP_MULT - 1) * delta
		self.vel.y += self.GRAVITY * delta
	
	self.vel = self.move_and_slide(self.vel, Vector2(0,-1))

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if $ReflectionRay.is_colliding():
			do_teleport($ReflectionRay.get_collision_point() + $ReflectionRay.get_collision_normal() * 64)

func _physics_process(delta):
	self.update()
	$RayCast2D.cast_to = get_local_mouse_position() * 10
	if $RayCast2D.is_colliding():
			$ReflectionRay.global_position = $RayCast2D.get_collision_point() + ($RayCast2D.get_collision_normal() * 0.01)
			$ReflectionRay.cast_to = -$RayCast2D.cast_to.reflect($RayCast2D.get_collision_normal())

func _draw():
	var raycast_start = $RayCast2D.get_position()
	var raycast_end = $RayCast2D.cast_to
	if $RayCast2D.is_colliding():
		raycast_end = to_local($RayCast2D.get_collision_point())
		var reflect_start = raycast_end + $RayCast2D.get_collision_normal() * 0.01
		var reflect_end = $ReflectionRay.cast_to
		if $ReflectionRay.is_colliding():
			reflect_end = to_local($ReflectionRay.get_collision_point())
		draw_dashed_line(reflect_start, reflect_end, Color(1,1,1), 1, 20)
	draw_dashed_line(raycast_start, raycast_end, Color(1,1,1), 1, 20)

func draw_dashed_line(from, to, color, width, dash_length = 5, cap_end = false, antialiased = false):
	var length = (to - from).length()
	var normal = (to - from).normalized()
	var dash_step = normal * dash_length
	
	if length < dash_length: #not long enough to dash
		draw_line(from, to, color, width, antialiased)
		return

	else:
		var draw_flag = true
		var segment_start = from
		var steps = length/dash_length
		for start_length in range(0, steps + 1):
			var segment_end = segment_start + dash_step
			if draw_flag:
				draw_line(segment_start, segment_end, color, width, antialiased)

			segment_start = segment_end
			draw_flag = !draw_flag
		
		if cap_end:
			draw_line(segment_start, to, color, width, antialiased)

func on_line_touch(area):
	get_tree().reload_current_scene()
	pass

func do_teleport(pos):
	self.global_position = pos
	points_list_list.append(walk_points)
	walk_points = PoolVector2Array()
	walk_points.append(self.global_position)
	walk_points.append(self.global_position)
	last_point = self.global_position
	
	color_list_list.append(walk_color)
	walk_color = PoolColorArray()
	walk_color.append(Color(1,0,0,1))
	walk_color.append(Color(1,0,0,1))
	get_parent().update()
	