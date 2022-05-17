extends Area2D

export(float) var speed = 60
export(float, 0, 1) var speed_random = .2
export(float, -2, 2) var gravity_scale = 1
var damage = 10

var dir = Vector2()

var shooter = null

var vsp = 0

func _ready():
	speed += rand_range(-speed*speed_random, speed*speed_random)

func _physics_process(delta):
	vsp += Global.current_manager.gravity*gravity_scale*delta
	global_position += dir*speed*delta
	global_position.y += vsp*delta
	
	for i in get_overlapping_bodies():
		if i.is_in_group("bullet_stopper"):
			if i != shooter:
				if i.has_method("damage"):
					i.damage(damage, shooter.global_position)
				queue_free()
