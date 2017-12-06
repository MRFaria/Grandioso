extends Camera2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const TRANSLATE_UP = Vector2(0, -100)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

var looking_up = false
var looking_down = false

func _fixed_process(delta):
	var look_up = Input.is_action_pressed("ui_up")
	var look_down = Input.is_action_pressed("ui_down")

	if look_up:
		self.set_global_pos(get_parent().get_global_pos() + TRANSLATE_UP)
	elif look_down:
		self.set_global_pos(get_parent().get_global_pos() - TRANSLATE_UP)
	else:
		self.set_global_pos(get_parent().get_global_pos())
		
		
#	elif look_up and looking_up:
#		self.translate(-LOOKUP) 
#		looking_up = false

		