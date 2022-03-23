extends Node2D

export(float) var gravity = 2000

func _ready():
	Global.current_manager = self
	
func _exit_tree():
	Global.current_manager = null
