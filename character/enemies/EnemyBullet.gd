extends KinematicBody2D
var velocity
var level = load("res://world/level1/Level1.tscn").instance()



var timer = Timer.new()
func _ready():
	timer.set_wait_time(1.0)
	timer.connect("timeout",self,"on_timeout")
	add_child(timer)
	timer.start()
	set_fixed_process(true)

	
func _fixed_process(delta):
	move(velocity)
	if is_colliding():
		var node = get_collider()
		if node.is_in_group("Player"):
			node.refresh()
			get_parent().get_parent().add_child(level)
			get_parent().queue_free()

			
		free()

func on_timeout():
	self.queue_free()