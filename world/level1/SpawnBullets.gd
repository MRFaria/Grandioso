extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var time = 0
var scene = load("res://player/Bullet.tscn")
func _ready():
	var timer = get_node("Timer")
	timer.set_wait_time(1)
	timer.connect("timeout",self,"on_timeout")
	timer.start()

	
func shoot():
	var bullet = scene.instance()
	bullet.position = get_global_position() + Vector2(0, 50)
	bullet.add_collision_exception_with(self) # don't want player to collide with bullet
	bullet.velocity = Vector2(10, 0)
	
	get_parent().add_child(bullet)

func on_timeout():
	shoot()