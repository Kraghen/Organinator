extends "res://Game Objects/Character/Character.gd"

onready var weapon = $Body/Weapon

export(String) var jump_button
export(String) var right_button
export(String) var left_button
export(String) var action_button

export(int) var player_numb

var last_hinput = 1

func _ready():
	acc = 7000
	fric = 2000
	
	# Organs
	var stats = PlayerData.player_stats[player_numb]
	
	hp_max = stats["hp_max"]
	hp_max = max(1, hp_max)
	hp = hp_max
	
	shield = stats["shield"]
	shield = clamp(shield, 0, 0.9)
	
	jump_spd = stats["jump_speed"]
	spd = stats["speed"]
	
	spd = max(100, spd)
	jump_spd = min(1850, jump_spd)
	
	# Choose color
	spr.material
	spr.material.set_shader_param("hud", Vector3(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1)))
	spr.material.set_shader_param("ben", Vector3(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1)))
	spr.material.set_shader_param("mave", Vector3(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1)))

func _physics_process(delta):
	# Move
	var hinput = Input.get_action_strength(right_button)-Input.get_action_strength(left_button)
	if hinput != 0:
		last_hinput = hinput
		
	move_horizontal(hinput, delta)
		
	if Input.is_action_just_pressed("fly"):
		vel = Vector2(-1300, -800)
	
	var cel = is_on_ceiling()
	var flr = is_on_floor()

	if Input.is_action_pressed(jump_button) && flr:
		jump()
	
	# Action
	shoot()
			
func _process(delta):
	# Hud
	$ProgressBar.value = lerp($ProgressBar.value, hp/hp_max, .1)
	$ProgressBar.visible = !is_dead

func shoot():
	if is_dead: return
	var shoot_dir = Vector2(look_dir.x*last_hinput, -abs(look_dir.y))
	if Input.is_action_pressed(action_button):
		if weapon.action(shoot_dir):
			sprite.rotation_degrees += rand_range(-15, 15)
