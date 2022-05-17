extends Node2D

const M_OFF = 30

onready var desc = $Desc
onready var sprite = $Sprite

onready var is_hovering = false
var is_chosen = false

var target_pos: Vector2

var json_path = ["res://Organer/normal_lung.json", 
				 "res://Organer/normal_heart.json",
				 "res://Organer/normal_fat.json",
				 "res://Organer/strong_legs.json",
				 "res://Organer/gravity_brain.json",
				 "res://Organer/ice_boots.json"][randi()%6]


func _ready():
	var text_data = OrganLoader.load_organ_data(json_path)
	
	var name_desc_stats = (text_data["name"]+"\n"+
						   text_data["desc"]+"\n\n"+
						   "Stats:\n"+
						   str(text_data["stats"])+"\n\n"+
						   "Takes "+str(text_data["space"])+" space")
	
	desc.visible = false
	desc.text = name_desc_stats
	
	sprite.texture = load(text_data["sprite"])
	
	yield(get_tree(), "idle_frame")
	target_pos = global_position


func _process(delta):
	# Tegn infobox
	desc.rect_global_position = get_global_mouse_position()+Vector2(M_OFF, 0)
	# Skalér spriten hvis man hover
	sprite.scale = sprite.scale.linear_interpolate(Vector2(1+int(is_hovering), 1+int(is_hovering)), .1)
	# Ændre farven
	sprite.modulate.a = lerp(sprite.modulate.a, clamp(.5+int(is_hovering),  .5, 1), .1)
	# Lerp til target pos
	global_position = global_position.linear_interpolate(target_pos, .06)
	
	# Hvis man ikke hover
	sprite.offset = Vector2()
	if !is_hovering:
		var dist_to_mouse = sprite.global_position-get_global_mouse_position()
		var move = (dist_to_mouse/10).clamped(10)
		sprite.offset = move


func _on_Mouse_mouse_entered():
	desc.visible = true
	z_index += 10
	is_hovering = true


func _on_Mouse_mouse_exited():
	desc.visible = false
	z_index -= 10
	is_hovering = false
