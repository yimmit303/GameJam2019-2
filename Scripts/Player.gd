extends KinematicBody2D

var vel = Vector2(0,0)
var max_speed = 400
var up = 1

var ACCEL = 4
var DEACCEL = 8
var GRAVITY = 1800
var JUMP_MULT = 1.5
var LOW_JUMP_MULT = 1

var timer = 2

var distance_moved = 64
var walk_points = PoolVector2Array()
var walk_color = PoolColorArray()
var points_list_list = []
var color_list_list = []
var last_point

var control = true

var charge_num = 0

var texture = load("Eye_Back.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	last_point = self.global_position
	walk_points.append(self.global_position)
	walk_points.append(self.global_position)
	walk_color.append(Color(1,0,0,1))
	walk_color.append(Color(1,0,0,1))
	if Globals.just_started:
		control = false
		#get_node("CanvasLayer/ColorRect").visible = true
		get_node("CanvasLayer/Title").visible = true
		get_node("CanvasLayer/Play").visible = true
		get_node("CanvasLayer/Exit").visible = true
		get_node("CanvasLayer/BlackFade").visible = true
		$Tween.interpolate_property(get_node("CanvasLayer/BlackFade"), "modulate", Color(0,0,0,1), Color(0,0,0,0), 1, Tween.TRANS_EXPO,Tween.EASE_IN_OUT)
		$Tween.start()
		get_node("Character").scale = Vector2(40,40)
	else:
		control = false
		var tween = $Swirl_Tween
		tween.interpolate_property($Character, "rotation_degrees", -720, 0, 1, Tween.TRANS_EXPO,Tween.EASE_IN_OUT)
		tween.interpolate_property($Character, "scale", Vector2(0,0), Vector2(1,1), 1, Tween.TRANS_EXPO,Tween.EASE_IN_OUT)
		tween.start()
		$Level_Entrance.play()
		yield(tween, "tween_all_completed")
		control = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !control:
		update_eye_menu()
	
	randomize()
	
	if (randi() % 500) == 0:
		blink()
	
	
	if Input.is_key_pressed(KEY_ESCAPE):
			get_tree().quit()
	
	if control:
		if self.position.y > 2000 or self.position.y < -5000:
			get_tree().reload_current_scene()
		squish()
		update_eye()
		update_charges()
		
		if self.global_position.distance_to(last_point) >= distance_moved:
			
			spawn_circles()
			
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
			if walk_points.size() >= 4:
				get_parent().add_area(walk_points[walk_points.size() - 4], walk_points[walk_points.size() - 3])
		
		var dir = Vector2(0,0)
		self.max_speed = 800
		
		if Input.is_key_pressed(KEY_D):
			dir.x += 1
		if Input.is_key_pressed(KEY_A):
			dir.x -= 1
		if Input.is_key_pressed(KEY_SPACE) and self.is_on_floor():
			self.vel.y = up * -2000
			$Jump.play()
		if Input.is_key_pressed(KEY_SHIFT):
			self.max_speed = 800
		if Input.is_key_pressed(KEY_R):
			get_tree().reload_current_scene()
		if Input.is_key_pressed(KEY_BACKSPACE):
			Globals.just_started = true
			get_tree().change_scene("Scenes/Level1.tscn")
			
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
				self.vel.y += up * self.GRAVITY * (self.JUMP_MULT) * delta
			elif (self.vel.y <= 0 and Input.is_action_pressed("Jump")):
				self.vel.y += up * self.GRAVITY * (self.LOW_JUMP_MULT) * delta
			self.vel.y += up * self.GRAVITY * delta
		
		self.vel = self.move_and_slide(self.vel, Vector2(0,-1 * up))

func _input(event):
	if control:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
			if $ReflectionRay.is_colliding():
				if charge_num > 0:
					do_teleport($ReflectionRay.get_collision_point() + $ReflectionRay.get_collision_normal() * 64)
					charge_num -= 1

func _physics_process(delta):
	self.update()
	$RayCast2D.cast_to = get_local_mouse_position().normalized() * 10000
	if $RayCast2D.is_colliding():
			$ReflectionRay.global_position = $RayCast2D.get_collision_point() + ($RayCast2D.get_collision_normal() * 0.01)
			$ReflectionRay.cast_to = -$RayCast2D.cast_to.reflect($RayCast2D.get_collision_normal())

func _draw():
	if charge_num > 0:
		var raycast_start = $RayCast2D.get_position()
		var raycast_end = $RayCast2D.cast_to
		if $RayCast2D.is_colliding():
			raycast_end = to_local($RayCast2D.get_collision_point())
			var reflect_start = raycast_end + $RayCast2D.get_collision_normal() * 0.01
			var reflect_end = $ReflectionRay.cast_to
			if $ReflectionRay.is_colliding():
				reflect_end = to_local($ReflectionRay.get_collision_point())
				draw_rect(Rect2(reflect_end - Vector2(64,64) + $ReflectionRay.get_collision_normal() * 64,Vector2(128,128)),Color(1,1,1,0.5),false)
			draw_dashed_line(reflect_start, reflect_end, Color(1,1,1,0.5), 1, 20)
		draw_dashed_line(raycast_start, raycast_end, Color(1,1,1,0.5), 1, 20)

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
	if(area.name == "ButtonArea"):
		return
	get_tree().reload_current_scene()

func do_teleport(pos):
	$Teleport.play()
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
	
func update_eye():
	var mouse_pos = get_local_mouse_position()
	var look_dir = mouse_pos.normalized()
	get_node("Character/Eye/Eye_Pupil").position = Vector2(0,0)
	get_node("Character/Eye/Eye_Pupil").position += look_dir * (25 * min(1, pow(mouse_pos.length(), 0.25)/5))

func update_eye_menu():
	var mouse_pos = get_local_mouse_position()
	var look_dir = mouse_pos.normalized()
	get_node("Character/Eye/Eye_Pupil").position = Vector2(0,0)
	get_node("Character/Eye/Eye_Pupil").position += look_dir * (25 * mouse_pos.length()/2400)

func blink():
	var blink_tween = $Tween
	blink_tween.interpolate_property(get_node("Character/Lid"), "scale", Vector2(0.1, 1), Vector2(0.5, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	blink_tween.interpolate_property(get_node("Character/Lid2"), "scale", Vector2(0.1, 1), Vector2(0.5, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	blink_tween.start()
	yield(blink_tween, "tween_all_completed")
	blink_tween.interpolate_property(get_node("Character/Lid"), "scale", Vector2(0.5, 1), Vector2(0.1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	blink_tween.interpolate_property(get_node("Character/Lid2"), "scale", Vector2(0.5, 1), Vector2(0.1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	blink_tween.start()
	
func squish():
	get_node("Character").scale.y = clamp((up * vel.y / -2000) * 1.7, 1, 1.7)
	get_node("Character").scale.x = max(1, (up * vel.y / -2000) * 0.8)

func flip_gravity():
	up *= -1

func add_charge():
	$Charge_Get.play()
	charge_num += 1

func update_charges():
	if charge_num > 0:
		get_node("CanvasLayer/Charge_Count").visible = true
		get_node("CanvasLayer/Charge_Count").text = "Charges: "
		for i in range(charge_num):
			get_node("CanvasLayer/Charge_Count").text += "I "
	else:
		get_node("CanvasLayer/Charge_Count").visible = false

func spawn_circles():
	$CircleRay.rotation_degrees = randi() % 180
	$CircleRay.cast_to *= up
	if $CircleRay.is_colliding():
		var spawn_point = $CircleRay.get_collision_point()
		var circle_sprite = Sprite.new()
		circle_sprite.texture = self.texture
		var spawn_size = clamp(randf(), 0.5, 2)
		circle_sprite.scale = Vector2(spawn_size,spawn_size)
		$Tween.interpolate_property(circle_sprite, "scale", Vector2(0,0), circle_sprite.scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		circle_sprite.scale = Vector2(0,0)
		circle_sprite.global_position = spawn_point
		if randi() % 2 == 0:
			circle_sprite.modulate = Color(0.3,0.3,0.4,1)
			get_parent().add_child(circle_sprite)
			get_parent().move_child(circle_sprite, 0)
		else:
			get_parent().add_child_below_node(self, circle_sprite)
		$Tween.start()

func do_exit_animation():
	control = false
	var tween = $Swirl_Tween
	tween.interpolate_property($Character, "rotation_degrees", -720, 0, 1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.interpolate_property($Character, "scale", Vector2(1,1), Vector2(0,0), 1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()
	$Level_Exit.play()
	yield(tween,"tween_all_completed")
