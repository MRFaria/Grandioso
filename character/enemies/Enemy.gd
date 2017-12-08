extends KinematicBody2D
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var time = 0
var scene = load("res://character/enemies/EnemyBullet.tscn")
func _ready():
	var timer = get_node("Timer")
	timer.set_wait_time(1)
	timer.connect("timeout",self,"on_timeout")
	timer.start()

	
func shoot():
	var bullet = scene.instance()
	bullet.set_pos(get_global_pos() + Vector2(0, 0))
	bullet.add_collision_exception_with(self) 
	bullet.velocity = Vector2(-10, 0)
	
	get_parent().add_child(bullet)

func on_timeout():
	shoot()
