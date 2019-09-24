extends KinematicBody2D
var velocity

var timer = Timer.new()

func _ready():

	timer.set_wait_time(1.0)
	timer.connect("timeout",self,"on_timeout")
	add_child(timer)
	timer.start()
	set_physics_process(true)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review

	
func _physics_process(_delta):  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	var collision = move_and_collide(velocity)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	if collision:
		var node = collision.collider
		if node.is_in_group("Destroyable_Objects"):
			node.queue_free()
			queue_free()
		elif node.is_in_group("Enemies"):
			node.queue_free()
			queue_free()

func on_timeout():
	self.queue_free()
