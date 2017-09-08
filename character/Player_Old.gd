extends KinematicBody2D

const JUMP_SPEED = 450
const FLOOR_NORMAL = Vector2(0,-1)
const SLOPE_SLIDE_STOP = 100.0
var gravity = Vector2(0, 1500.0)
var velocity = Vector2()
var anim = ""
var jumping = false
onready var sprite = get_node("SpriteSheet")
onready var animator = get_node("AnimationPlayer")
onready var skill = get_node("SkillQueue")
var scene = load("res://player/Bullet.tscn")
var barrier_scene = load("res://player/Barrier.tscn")

func handle_move(move_left, move_right, sprite):
	var new_anim = ""
	var speed = 140
	
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

func cast_spell():
	print(get_node("SkillQueue").current_combo)
	if get_node("SkillQueue").current_combo == "[Q]":
		shoot()
	if get_node("SkillQueue").current_combo == "[E]":
		cast_barrier()

func shoot():
	var bullet = scene.instance()
	bullet.position = get_global_position()
	bullet.add_collision_exception_with(self) # don't want player to collide with bullet
	bullet.velocity = Vector2(sprite.scale.x * 10, 0)
	
	get_parent().add_child(bullet)

func cast_barrier():
	var barrier = barrier_scene.instance()
	#barrier.position = get_global_position()
	barrier.add_collision_exception_with(self) # don't want player to collide with bullet
	
	add_child(barrier)
	
func _ready():
	set_fixed_process(true)
	set_process_input(true)
	animator.set_active(true)
	get_node("SkillQueue").connect("combo", self, "cast_spell")
	#get_parent().get_node("Map/Bounds/Left").connect("body_entered", self, "body_entered")
	#get_parent().get_node("Map/Bounds/Right").connect("body_entered", self, "body_entered")
	#get_parent().get_node("Map/Bounds/Up").connect("body_entered", self, "body_entered")
	#get_parent().get_node("Map/Bounds/Down").connect("body_entered", self, "body_entered")


func body_entered(body):
	position = Vector2(100, 100)


func _fixed_process(delta):
	var new_anim = anim
	var move_left = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	
	# Apply Gravity
	velocity += delta * gravity
	# Move and Slide
	velocity = move_and_slide( velocity, FLOOR_NORMAL, SLOPE_SLIDE_STOP )

	#This is the vertical motion logic
	if is_on_floor():
		new_anim = handle_move(move_left, move_right, sprite)
		if jump:
			new_anim = "jump"
			velocity.y -= JUMP_SPEED
			move(velocity * delta)
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
		new_anim = "fall"
	
	
	if new_anim != anim:
		anim = new_anim
		animator.play(anim)

