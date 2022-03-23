extends Camera2D

export(Array, NodePath) var targets_path
var targets = []

var target_pos = Vector2()

onready var start_pos = global_position

func _ready():
	for i in range(len(targets_path)):
		targets.append(get_node(targets_path[i]))
		
func _process(delta):
	target_pos = (targets[0].global_position+targets[1].global_position)/2
	
	global_position = global_position.linear_interpolate(start_pos+(target_pos-global_position)/2, .1)
