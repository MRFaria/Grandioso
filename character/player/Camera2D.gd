extends Camera2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const TRANSLATE_UP = Vector2(0, -100)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _physics_process(delta):  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	var look_up = Input.is_action_pressed("ui_up")
	var look_down = Input.is_action_pressed("ui_down")

	if look_up:
		self.set_global_position(get_parent().get_global_position() + TRANSLATE_UP)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	elif look_down:
		self.set_global_position(get_parent().get_global_position() - TRANSLATE_UP)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	else:
		self.set_global_position(get_parent().get_global_position())  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review

