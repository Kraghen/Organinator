extends Control

onready var space_text = $VBoxContainer/Spaceleft
onready var player_text = $VBoxContainer/PlayerText
onready var stat_text = $VBoxContainer/Stats

var player_numb = 1
var space_left: int

func _ready():
	yield(get_tree(), "idle_frame")
	player_text.text = "Player"+str(player_numb)

func _process(delta):
	space_text.text = "Space left: "+str(space_left)
