extends Node2D

#var organ_paths = ["res://Organer/normal_heart.json"]

func make_add_data(organ_paths):
	var add_data = {
		"hp_max": 0,
		"hp_regen": 0,
		"strength": 0,
		"speed": 0,
		"acc": 0,
		"fric": 0,
		"jump_speed": 0,
		"gravity_scale": 0,
		"shield": 0
	}
	
	var organs = []
	for i in organ_paths:
		organs.append(load_organ_data(i)["stats"])
		
	for stats in organs:
		for stat in stats:
			add_data[stat] += stats[stat]
	
	return add_data

func make_final_organ_data(organ_paths):
	var new_data = {
		"hp_max": 100.0,
		"hp_regen": 0,
		"strength": 1,
		"speed": 500,
		"acc": 7000,
		"fric": 2000,
		"jump_speed": 800,
		"gravity_scale": 1,
		"shield": 0
	}

	var add = make_add_data(organ_paths)
	
	for stat in add:
		new_data[stat] += add[stat]
	
	return new_data

func load_organ_data(path):
	var file = File.new()
	file.open(path, File.READ)
	var content_as_text = file.get_as_text()
	var content_as_dictionary = parse_json(content_as_text)
	#file.close()
	return content_as_dictionary
