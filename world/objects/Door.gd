extends Area2D

func _on_Door_body_entered(body):
	if body.is_in_group("Player"):
		get_node("Open").visible = !(false)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review

func _on_Door_body_exited(body):
	if body.is_in_group("Player"):
		get_node("Open").visible = !(true)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
