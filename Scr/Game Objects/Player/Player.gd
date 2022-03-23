extends KinematicBody2D

onready var sprite = $Body
onready var weapon = $Body/Weapon
onready var weapon_pos = $Sprite/WeaponPos

export(String) var jump_button
export(String) var right_button
export(String) var left_button
export(String) var action_button

var grv = 2000

var snap_vector = Vector2.DOWN*32
var look_dir = Vector2()
var wave_rot = 0

var vel = Vector2()

var spd = 540
var acc = 4000
var fric = 2000

var walk_timer = 0

var last_hinput = 1

func _ready():
	yield(get_tree(), "idle_frame")
	grv = Global.current_manager.gravity
	Engine.time_scale = 1

func _physics_process(delta):
	# Move
	var hinput = Input.get_action_strength(right_button)-Input.get_action_strength(left_button)
	if hinput != 0:
		last_hinput = hinput
		
	var is_moving = hinput != 0
		
	if Input.is_action_just_pressed("fly"):
		vel = Vector2(-1000, -800)

	#vel.x = lerp(vel.x, hinput*spd, .1)
	vel.x = Global.approach(vel.x, 0, fric*delta)
	if is_moving && abs(vel.x) < spd: vel.x = Global.approach(vel.x, spd*hinput, acc*delta)
	
	var cel = is_on_ceiling()
	var flr = is_on_floor()
	
	if cel || flr:
		vel.y = 0
	
	if !flr:
		vel.y += grv*delta
	else:
		snap_vector = Vector2.DOWN*10
		if Input.is_action_pressed(jump_button):
			jump()
			
		look_dir = get_floor_normal()
		look_dir = Vector2(-look_dir.y, look_dir.x)
			
		sprite.rotation_degrees = rad2deg(look_dir.angle())+wave_rot
		
	#print(vel)
	move_and_slide_with_snap(vel, snap_vector, Vector2.UP, true)
	
	# Action
	var shoot_dir = Vector2(look_dir.x*last_hinput, -abs(look_dir.y))
	if Input.is_action_pressed(action_button):
		if weapon.action(shoot_dir):
			sprite.rotation_degrees += rand_range(-15, 15)
	
	# Animation
	if hinput != 0:
		sprite.scale.x = hinput
		
		walk_timer += 1
		wave_rot = Global.wave(-10, 10, .01, 0, walk_timer)
	else: 
		walk_timer = 0
		wave_rot = 0
		
	sprite.scale.y = lerp(sprite.scale.y, max(.4, min(1.5, vel.y/800+1)), 1)
	
func jump():
	snap_vector = Vector2()
	vel.y = -800
