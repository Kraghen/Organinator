extends "res://Game Objects/Character/Character.gd"

onready var weapon = $Body/Weapon

export(String) var jump_button
export(String) var right_button
export(String) var left_button
export(String) var action_button

var last_hinput = 1

func _ready():
	acc = 7000
	fric = 2000

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
	var shoot_dir = Vector2(look_dir.x*last_hinput, -abs(look_dir.y))
	if Input.is_action_pressed(action_button):
		if weapon.action(shoot_dir):
			sprite.rotation_degrees += rand_range(-15, 15)
			
func _process(delta):
	# Hud
	$ProgressBar.value = hp/hp_max
