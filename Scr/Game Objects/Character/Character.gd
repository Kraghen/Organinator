extends KinematicBody2D

onready var sprite = $Body

var grv = 2000

var snap_vector = Vector2.DOWN*32
var look_dir = Vector2()
var wave_rot = 0

var vel = Vector2()

var spd = 540
var acc = 4000
var fric = 2000

var walk_timer = 0

var can_move = true
var is_dead = false

var xdir = 1

var jump_spd = 800
var is_jumping = false

var hp = 100.0
var hp_max = hp

func _ready():
	yield(get_tree(), "idle_frame")
	grv = Global.current_manager.gravity

func _physics_process(delta):
	# Move
	var is_moving = abs(vel.x) > 0
	#if sign(vel.x) != 0: xdir = sign(vel.x) 

	vel.x = Global.approach(vel.x, 0, fric*delta)
	
	var cel = is_on_ceiling()
	var flr = is_on_floor()
	
	if (cel || flr):
		vel.y = 0
	
	if !flr:
		vel.y += grv*delta
	elif (!is_dead) && can_move:
		if is_jumping:
			vel.y = -jump_spd
		else:
			snap_vector = Vector2.DOWN*10
		look_dir = get_floor_normal()
		look_dir = Vector2(-look_dir.y, look_dir.x)
			
		sprite.rotation_degrees = rad2deg(look_dir.angle())+wave_rot
		
	is_jumping = false
		
	move_and_slide_with_snap(vel, snap_vector, Vector2.UP, true)
	
	# Animation
	if is_moving:
		sprite.scale.x = xdir
		
		walk_timer += 1
		wave_rot = Global.wave(-20, 20, .01, 0, walk_timer)
	else: 
		walk_timer = 0
		wave_rot = 0
		
	sprite.scale.y = lerp(sprite.scale.y, max(.4, min(1.5, vel.y/800+1)), 1)
	
func jump():
	snap_vector = Vector2()
	is_jumping = true
	#vel.y = -800
	
func move_horizontal(hinput, delta):
	if !can_move || is_dead: return
	if abs(vel.x) < spd: vel.x = Global.approach(vel.x, spd*hinput, acc*delta)
	if hinput != 0: xdir = hinput

func die():
	if !is_dead:
		# Lorte hard koded shit
		#jump()
		vel.y = -400
		
		sprite.global_rotation_degrees = 90
		is_dead = true
		can_move = false

func damage(amount, from_pos := Vector2(), knockback : float = 500):
	hp -= amount
	var kb = knockback*((global_position-from_pos).normalized())
	vel.y = -400
	vel.x = kb.x
	
	if hp <= 0:
		die()
