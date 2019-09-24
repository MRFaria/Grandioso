extends KinematicBody2D
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var timer = Timer.new()
	timer.set_wait_time(1)
	timer.connect("timeout",self,"on_timeout")
	add_child(timer) 
	timer.start()

func on_timeout():
	self.queue_free()
