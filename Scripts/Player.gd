extends KinematicBody2D

var vel = Vector2(0,0)
var max_speed = 400
var up = Vector2(0, -1)

var ACCEL = 4
var DEACCEL = 8
var GRAVITY = 1800
var JUMP_MULT = 2.5
var LOW_JUMP_MULT = 2
var distance_moved = 128

var walk_points = PoolVector2Array()
var last_point


# Called when the node enters the scene tree for the first time.
func _ready():
	last_point = self.global_position
	walk_points.append(self.global_position)
	walk_points.append(self.global_position)

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if self.global_position.distance_to(last_point) >= distance_moved:
#		print(last_point)
#		print((self.global_position - last_point).length())
		last_point = walk_points[walk_points.size() - 1]
		walk_points.append(self.global_position)
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

func on_line_touch(area):
	#get_tree().reload_current_scene()
	pass