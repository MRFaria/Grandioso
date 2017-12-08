extends KinematicBody2D
var velocity

var timer = Timer.new()
onready var root = get_tree().get_root().get_node("Level1")

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
		if node.is_in_group("Destroyable_Objects"):
			node.queue_free()
			queue_free()
		elif node.is_in_group("Enemies"):
			node.queue_free()
			queue_free()

func on_timeout():
	self.queue_free()