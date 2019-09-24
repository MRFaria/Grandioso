extends KinematicBody2D

onready var sprite = get_node("SpriteSheet")
onready var animator = get_node("AnimationPlayer")
var bullet_scene = load("res://character/player/Bullet.tscn")
var bullet_scene2 = load("res://character/player/Bullet2.tscn")
var barrier_scene = load("res://character/player/Barrier.tscn")

var anim = "idle"
const JUMP_SPEED = 450
const FLOOR_NORMAL = Vector2(0,-1)
const SLOPE_SLIDE_STOP = 100.0
var RESET_POS
const RESET_FLOOR = 3000
var gravity = Vector2(0, 1500.0)
var velocity = Vector2(0, 0)
var jumping = false
var health_points = 2

func _ready():
	set_physics_process(true)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	animator.set_active(true)
	get_node("ComboQueue").connect("combo", self, "cast_spell")
	RESET_POS = sprite.get_global_position()  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	

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
	bullet.set_position(get_global_position())  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	#bullet.add_collision_exception_with(self) # don't want player to collide with bullet
	var sprite_scale = sprite.get_scale()
	bullet.velocity = Vector2(sprite_scale.x * 10, 0)
	get_parent().add_child(bullet)

func shoot_big_spell():
	print("shooting 2")
	var bullet = bullet_scene2.instance()
	bullet.set_position(get_global_position())  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	#bullet.add_collision_exception_with(self) # don't want player to collide with bullet
	var sprite_scale = sprite.get_scale()
	bullet.velocity = Vector2(sprite_scale.x * 10, 0)	
	get_parent().add_child(bullet)

func barrier_spell():
	var barrier = barrier_scene.instance()
	barrier.add_collision_exception_with(self) # don't want player to collide with bullet
	add_child(barrier)

func handle_move_and_collide(move_left, move_right, sprite):  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
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
	set_global_position(RESET_POS)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review

func _physics_process(delta):  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	var new_anim = anim
	var move_left = Input.is_action_pressed("ui_left")
	var move_right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_pressed("jump")
	var menu = Input.is_action_pressed("menu")
	
	if get_global_position()[1] > RESET_FLOOR:  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
		refresh()
	
	if is_on_floor():  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
		new_anim = handle_move_and_collide(move_left, move_right, sprite)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
		if jump:
			new_anim = "jump"
			velocity.y -= JUMP_SPEED
			jumping = true
		else:
			jumping = false
	elif jumping:
		handle_move_and_collide(move_left, move_right, sprite)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
		if jump && (velocity.y < 0):
			gravity = Vector2(0, 600.0)
		else:
			new_anim = "fall"
			gravity = Vector2(0, 1500.0)
	elif not jumping:
		handle_move_and_collide(move_left, move_right, sprite)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
		if abs(velocity.y) > 500:
			new_anim = "fall"

	velocity += delta * gravity
	velocity = move_and_slide(velocity, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	
	if new_anim != anim:
		anim = new_anim
		animator.play(anim)

