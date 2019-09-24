extends Camera2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const TRANSLATE_UP = Vector2(0, -100)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _physics_process(_delta):
	var look_up = Input.is_action_pressed("ui_up")
	var look_down = Input.is_action_pressed("ui_down")

	if look_up:
		self.set_global_position(get_parent().get_global_position() + TRANSLATE_UP)
	elif look_down:
		self.set_global_position(get_parent().get_global_position() - TRANSLATE_UP)
	else:
		self.set_global_position(get_parent().get_global_position())

