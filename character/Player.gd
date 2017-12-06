extends KinematicBody2D

onready var sprite = get_node("SpriteSheet")
onready var animator = get_node("AnimationPlayer")
var bullet_scene = load("res://character/Bullet.tscn")
var bullet_scene2 = load("res://character/Bullet2.tscn")
var barrier_scene = load("res://character/Barrier.tscn")
var menu_scene = load("res://gui/Menu.tscn")

var anim = "idle"
const JUMP_SPEED = 450
const FLOOR_NORMAL = Vector2(0,-1)
const SLOPE_SLIDE_STOP = 100.0
var RESET_POS
const RESET_FLOOR = 3000
var gravity = Vector2(0, 1500.0)
var velocity = Vector2(0, 0)
var jumping = false

func _ready():
	set_fixed_process(true)
	animator.set_active(true)
	get_node("ComboQueue").connect("combo", self, "cast_spell")
	RESET_POS = sprite.get_global_pos()
	
func open_menu():
	# todo
	get_parent().add_child(menu_scene)
	

func cast_spell():
	print(get_node("ComboQueue").current_combo)
	if get_node("ComboQueue").current_combo == "[Q]":
		shoot_small_spell()
	if get_node("ComboQueue").current_combo == "[E]":
		barrier_spell()
	if get_node("ComboQueue").current_combo == "[Q, Q]":
		shoot_big_spell()

func shoot_small_spell():
	var bullet = bullet_scene.instance()
	bullet.set_pos(get_global_pos())
	#bullet.add_collision_exception_with(self) # don't want player to collide with bullet
	var sprite_scale = sprite.get_scale()
	bullet.velocity = Vector2(sprite_scale.x * 10, 0)
	get_parent().add_child(bullet)

func shoot_big_spell():
	print("shooting 2")
	var bullet = bullet_scene2.instance()
	bullet.set_pos(get_global_pos())
	#bullet.add_collision_exception_with(self) # don't want player to collide with bullet
	var sprite_scale = sprite.get_scale()
	bullet.velocity = Vector2(sprite_scale.x * 10, 0)	
	get_parent().add_child(bullet)

func barrier_spell():
	var barrier = barrier_scene.instance()
	barrier.add_collision_exception_with(self) # don't want player to collide with bullet
	add_child(barrier)

func handle_move(move_left, move_right, sprite):
	var new_anim = ""
	var speed = 200
	
	if move_left == true:
		new_anim = "run"
		velocity.x = -speed
		sprite.set_scale(Vector2(-1, 1))
	
	elif move_right == true:
		new_anim = "run"
		velocity.x = speed
		sprite.set_scale(Vector2(1,1))
	
	else:
		new_anim = "idle"
		velocity.x = 0

	return new_anim

func refresh():
	velocity = Vector2(0, 0)
	set_global_pos(RESET_POS)

func _fixed_process(delta):
	var new_anim = anim
	var move_left = Input.is_action_pressed("ui_left")
	var move_right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_pressed("jump")
	var menu = Input.is_action_pressed("menu")
	
	# ToDo
	#if menu:
	#	open_menu()
	if get_global_pos()[1] > RESET_FLOOR:
		refresh()
	
	if is_move_and_slide_on_floor():
		new_anim = handle_move(move_left, move_right, sprite)
		if jump:
			new_anim = "jump"
			velocity.y -= JUMP_SPEED
			jumping = true
		else:
			jumping = false
	elif jumping:
		handle_move(move_left, move_right, sprite)
		if jump && (velocity.y < 0):
			gravity = Vector2(0, 600.0)
		else:
			new_anim = "fall"
			gravity = Vector2(0, 1500.0)
	elif not jumping:
		handle_move(move_left, move_right, sprite)
		if abs(velocity.y) > 500:
			new_anim = "fall"

	velocity += delta * gravity
	velocity = move_and_slide(velocity, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	
	if new_anim != anim:
		anim = new_anim
		animator.play(anim)
