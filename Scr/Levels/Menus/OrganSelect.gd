extends Control

onready var organ_text = $OrganText
onready var o_start_pos = organ_text.rect_global_position

onready var organ_container = $Organs
onready var turn_text = $Label
var turn = randi()%2

onready var player1 = $MenuPlayerOrganContainer

func _ready():
	player1.rect_global_position.x = (Global.WWIDTH/3)-(player1.rect_size.x)

func _process(delta):
	organ_text.rect_global_position.y = Global.wave(o_start_pos.y-10, o_start_pos.y+10, .004, 0, Global.time)
	
	# Choose organs
	var turn_string = "Player"+str(turn+1)+"s turn to choose organ"
	turn_text.text = turn_string
	
	if organ_container.find_hovered_organ() != -1:
		if Input.is_action_just_pressed("left_mouse"):
			var org = organ_container.organs[organ_container.find_hovered_organ()]
			org.target_pos = Vector2()
			org.is_chosen = true
			
			turn += 1
			turn = turn%2
