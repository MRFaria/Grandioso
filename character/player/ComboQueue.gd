extends Node

signal combo

var combo_queue = []
var current_combo = []

var wait_time = 0.15
var timer

var skillq 
var skillr 
var skille 

func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(wait_time)
	timer.connect("timeout", self, "on_timeout_complete")

	add_child(timer)
	current_combo = ""
	set_process_input(true)

func on_timeout_complete():
	current_combo = str(combo_queue)
	emit_signal("combo")
	combo_queue = []
	
func _input(event):
	skillq = event.is_action_pressed("skill_q")
	skillr = event.is_action_pressed("skill_r")
	skille = event.is_action_pressed("skill_e")
	
	if skillq or skillr or skille:
		if timer.get_time_left() == 0.0:
			timer.start()
		else:
			timer.set_pause_mode(1)		

	if timer.get_time_left() > 0:
		if skillq:
			combo_queue.append("Q")
		elif skillr:
			combo_queue.append("R")
		elif skille:
			combo_queue.append("E")

#
