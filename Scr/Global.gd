extends Node

var player = null
var current_manager = null

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		#SceneChanger.change_scene(get_tree().current_scene.filename, "Diamond")
		get_tree().reload_current_scene()

func wave(from, to, duration, offset, time):
	var _wave = (to - from) * 0.5
	return from + _wave + sin((((time * 0.001) + duration * offset) / duration) * (PI * 2)) * _wave

func instance_create(obj, parrent):
	var inst = obj.instance()
	parrent.add_child(inst)
	return inst
	
func instance_create_position(obj, parrent, pos):
	var inst = instance_create(obj, parrent)
	inst.global_position = pos
	return inst