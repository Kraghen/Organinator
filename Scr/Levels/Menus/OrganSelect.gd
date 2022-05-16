extends Control

onready var organ_text = $OrganText
onready var o_start_pos = organ_text.rect_global_position

onready var organ_container = $Organs
onready var turn_text = $Label
var turn = randi()%2

onready var player1 = $MenuPlayerOrganContainer

var player_stats = [[], []]

func _ready():
	player1.rect_global_position.x = (Global.WWIDTH/3)-(player1.rect_size.x)

func _process(delta):
	organ_text.rect_global_position.y = Global.wave(o_start_pos.y-10, o_start_pos.y+10, .004, 0, Global.time)
	
	# Choose organs
	var turn_string = "Player"+str(turn+1)+"s turn to choose organ"
	turn_text.text = turn_string
	
	
	if organ_container.find_hovered_organ() != -1:
		var orgh = organ_container.organs[organ_container.find_hovered_organ()]
		if !orgh.is_chosen:
			if Input.is_action_just_pressed("left_mouse"):
				
				orgh.target_pos.x = -64 if turn == 0 else Global.WWIDTH
				orgh.is_chosen = true
				
				
				player_stats[turn].append(orgh.json_path)
				
				turn += 1
				turn = turn%2

func finalize_stats():
	PlayerData.player_stats = [OrganLoader.make_final_organ_data(player_stats[0]), OrganLoader.make_final_organ_data(player_stats[1])]


func _on_Play_pressed():
	finalize_stats()
	SceneChanger.change_scene("res://Levels/TestLevel.tscn", "Diamond")
