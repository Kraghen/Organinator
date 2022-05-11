extends Sprite

const M_OFF = 30

func _ready():
	$Desc.visible = false
	
func _process(delta):
	$Desc.rect_global_position = get_global_mouse_position()+Vector2(M_OFF, 0)

func _on_Mouse_mouse_entered():
	$Desc.visible = true


func _on_Mouse_mouse_exited():
	$Desc.visible = false
