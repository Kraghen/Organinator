extends Node2D

export(PackedScene) var bullet_type

var can_shoot = true

var random_ness = .5

func action(dir):
	if can_shoot:
		if $Timer.is_stopped():
			$Timer.start()
		can_shoot = false
		for i in range(10):
			var inst = Global.instance_create_position(bullet_type,
							get_parent().get_parent().get_parent(),
							global_position)
							
			inst.dir = (dir+Vector2(rand_range(-random_ness, random_ness), rand_range(-random_ness, random_ness))).normalized()
			inst.shooter = owner
			inst = null
			
		return true
	
	return false



func _on_Timer_timeout():
	can_shoot = true
