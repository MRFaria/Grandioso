extends CanvasLayer
var main_menu_scene = load("res://gui/MainMenu.tscn")
var main_menu_state = false
var main_menu_instance

func _ready():
	set_process_input(true)

	
func _input(event):
	var bullet
	
	if event.is_action_pressed("menu"):
		if !main_menu_state:
			main_menu_instance = main_menu_scene.instance()
			add_child(main_menu_instance)
		else:
			main_menu_instance.free()
		main_menu_state = not main_menu_state



