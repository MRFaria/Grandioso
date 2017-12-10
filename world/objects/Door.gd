extends Area2D

func _ready():
	connect("body_enter", self, "_on_body_enter")
	connect("body_exit", self, "_on_body_exit")

func _on_body_enter(body):
	if body.is_in_group("Player"):
		get_node("Open").set_hidden(false)
	
func _on_body_exit(body):
	if body.is_in_group("Player"):
		get_node("Open").set_hidden(true)