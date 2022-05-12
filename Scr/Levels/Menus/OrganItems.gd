extends Panel

const TSIZE = 64

var organs = []

func _ready():
	for x in range(rect_size.x/TSIZE):
		for y in range(rect_size.y/TSIZE):
			organs.append(Global.instance_create_position(preload("res://Game Objects/OrganStuff/MenuOrgan/MenuOrgan.tscn"), self, rect_global_position+Vector2(x, y)*TSIZE))
			organs[len(organs)-1].target_pos = rect_global_position+Vector2(x, y)*TSIZE
			
func find_hovered_organ():
	for i in organs:
		if i.is_hovering:
			return organs.find(i)
	return -1
