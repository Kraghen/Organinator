extends Panel

const TSIZE = 64

func _ready():
	for x in range(rect_size.x/TSIZE):
		for y in range(rect_size.y/TSIZE):
			Global.instance_create_position(preload("res://Game Objects/OrganStuff/MenuOrgan/MenuOrgan.tscn"), self, rect_global_position+Vector2(x, y)*TSIZE)
