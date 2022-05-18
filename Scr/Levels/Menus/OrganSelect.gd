extends Control

onready var organ_text = $OrganText
onready var o_start_pos = organ_text.rect_global_position

onready var organ_container = $Organs
onready var turn_text = $Label
var turn = randi()%2

onready var player1 = $MenuPlayerOrganContainer
onready var player2 = $MenuPlayerOrganContainer2

var player_stats = [[], []]
var player_space_left = [15, 15]

func _ready():
	var buff = 100
	player2.rect_global_position.x = (Global.WWIDTH/3)-buff
	player1.rect_global_position.x = (Global.WWIDTH/3)*2+buff
	
	player1.player_numb = 1
	player2.player_numb = 2
	
	finalize_stats()

func _process(delta):
	organ_text.rect_global_position.y = Global.wave(o_start_pos.y-10, o_start_pos.y+10, .004, 0, Global.time)
	
	# Choose organs
	var turn_string = "Player"+str(turn+1)+"s turn to choose organ"
	turn_text.text = turn_string
	
	
	if organ_container.find_hovered_organ() != -1:
		var orgh = organ_container.organs[organ_container.find_hovered_organ()]
		var space_to_take = OrganLoader.load_organ_data(orgh.json_path)["space"]
		if !orgh.is_chosen and space_to_take <= player_space_left[turn]:
			if Input.is_action_just_pressed("left_mouse"):
				
				orgh.target_pos.x = -66 if !turn == 0 else Global.WWIDTH
				orgh.is_chosen = true
				
				player_stats[turn].append(orgh.json_path)
				
				# Take space
				player_space_left[turn] -= space_to_take
				
				# Change turn
				turn += 1
				turn = turn%2
				
				finalize_stats()
				
	
	# Draw players
	var stat_text = "Stats: \n"
	player1.stat_text.text = stat_text+str(PlayerData.player_stats[0])
	player2.stat_text.text = stat_text+str(PlayerData.player_stats[1])
	
	player1.space_left = player_space_left[0]
	player2.space_left = player_space_left[1]

func finalize_stats():
	PlayerData.player_stats = [OrganLoader.make_final_organ_data(player_stats[0]), OrganLoader.make_final_organ_data(player_stats[1])]


func _on_Play_pressed():
	finalize_stats()
	SceneChanger.change_scene("res://Levels/TestLevel.tscn", "Diamond")


func _on_SkipTurn_pressed():
	turn += 1
	turn = turn%2
