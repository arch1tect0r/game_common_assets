extends KinematicBody2D

const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const MIN_ONAIR_TIME = 0.1
const WALK_SPEED = 250 # pixels/sec
const JUMP_SPEED = 480
const SIDING_CHANGE_SPEED = 10
export var BULLET_VELOCITY = 1000

var linear_vel = Vector2()
var onair_time = 0 #
var on_floor = false
var shoot_time=99999 #time since last shot
var cur_shooting_speed = 0.1
var is_shoot_ready = true

var anim=""

#cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = $sprite

var current_weapon = 'bullet'

func get_weapon(gun,shooting_speed):
	print(gun + ' was got')
	cur_shooting_speed = shooting_speed
	$shooting_speed.wait_time = cur_shooting_speed
	current_weapon = gun
	pass

func shot():
	if (is_shoot_ready):
		#var bullet = preload("res://common_assets/Player/bullets/bullet.tscn").instance()
		var bullet = load("res://common_assets/Bullets/"+current_weapon+".tscn").instance()
		bullet.position = $sprite/start_bullet_postion.global_position #use node for shoot position
		bullet.linear_velocity = Vector2(sprite.scale.x * BULLET_VELOCITY, 0)
		bullet.add_collision_exception_with(self) # don't want player to collide with bullet
		get_parent().add_child(bullet) #don't want bullet to move with me, so add it as child of parent
		#$sound_shoot.play()
		shoot_time = 0
		is_shoot_ready = false
		$shooting_speed.start()

func _physics_process(delta):
	#increment counters

	onair_time += delta
	shoot_time += delta

	### MOVEMENT ###

	# Apply Gravity
	linear_vel += delta * GRAVITY_VEC
	# Move and Slide
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	# Detect Floor
	if is_on_floor():
		onair_time = 0

	on_floor = onair_time < MIN_ONAIR_TIME

	### CONTROL ###

	# Horizontal Movement
	var target_speed = 0
	if Input.is_action_pressed("ui_left"):
		target_speed += -1
	if Input.is_action_pressed("ui_right"):
		target_speed +=  1

	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)

	# Jumping
	if on_floor and (Input.is_joy_button_pressed(0,JOY_BUTTON_1) || Input.is_action_just_pressed("ui_up")):
		linear_vel.y = -JUMP_SPEED
		#$sound_jump.play()
		
	# Shooting
	if Input.is_joy_button_pressed(0,JOY_BUTTON_0) || Input.is_key_pressed(KEY_SPACE): #Input.is_action_just_pressed("btn_spacebar"):
		shot()

	### ANIMATION ###

	var new_anim = "idle"

	if on_floor:
		if linear_vel.x < -SIDING_CHANGE_SPEED:
			sprite.scale.x = -1
			new_anim = "run"

		if linear_vel.x > SIDING_CHANGE_SPEED:
			sprite.scale.x = 1
			new_anim = "run"
	else:
		# We want the character to immediately change facing side when the player
		# tries to change direction, during air control.
		# This allows for example the player to shoot quickly left then right.
		if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			sprite.scale.x = -1
		if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
			sprite.scale.x = 1

		if linear_vel.y < 0:
			new_anim = "jumping"
		#else:
			#new_anim = "falling"

	#if shoot_time < cur_shooting_speed:
		#new_anim += "_weapon"

	if new_anim != anim:
		anim = new_anim
		$anim.play(anim)

func hit_by_enemy():
	$GUI.deacrease_hp()

func _on_shooting_speed_timeout():
	is_shoot_ready = true
