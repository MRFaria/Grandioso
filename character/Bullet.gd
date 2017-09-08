extends KinematicBody2D
var velocity
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var timer = Timer.new()

func _ready():
	timer.set_wait_time(1.0)
	timer.connect("timeout",self,"on_timeout")
	add_child(timer)
	timer.start()
	set_fixed_process(true)

	
func _fixed_process(delta):
	move(velocity)

func on_timeout():
	self.queue_free()