extends KinematicBody2D

signal player_died
signal player_hp_changed
signal player_win
signal player_weapon_changed

onready var sprite = $sprite
onready var camera = $camera
onready var dialog_open = preload("res://common_assets/GUI/offers/open.tscn")


const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 15.0
const MIN_ONAIR_TIME = 0.1
const WALK_SPEED = 150 # pixels/sec
const JUMP_SPEED = 250
const SIDING_CHANGE_SPEED = 10
const CAMERA_RETURNING_SPEED = 0.3
const CAMERA_MAX_OFFSET = 100
var BULLET_VELOCITY = 300

var linear_vel = Vector2()
var onair_time = 0 #
var on_floor = false
var cur_shooting_speed = 0.5
var is_shoot_ready = true
var shoot_time = 0

var anim=""

var current_dialog;

var current_weapon = '10'
var current_jump_count = 0
var jump_count = 2
export var count_hearts = 3
var is_dialog_open = false

func _ready():
	pass

func get_weapon(gun,shooting_speed):
	cur_shooting_speed = shooting_speed
	current_weapon = gun
	emit_signal("player_weapon_changed",current_weapon)
	pass

func shot():
	if (is_shoot_ready):
		is_shoot_ready = false
		var bullet = load("res://common_assets/Bullets/"+current_weapon+".tscn").instance()
		bullet.position = $sprite/start_bullet_postion.global_position
		bullet._add_scale(sprite.scale*0.5)
		bullet.linear_velocity = Vector2(sprite.scale.x * BULLET_VELOCITY, 0)
		get_parent().add_child(bullet)
		shoot_time = 0

func hit_by_hand_weapon():
	if (is_shoot_ready):
		is_shoot_ready = false
		var weapon = load("res://common_assets/oneHandWeapon/Axe.tscn").instance()
		$sprite/hand_weapon_attack_point.scale.x = $sprite.scale.x
		weapon.position = $sprite/hand_weapon_attack_point.position

		#weapon._add_scale = Vector2(sprite.scale.x,1)
		weapon.add_collision_exception_with(self)
		self.add_child(weapon)
		weapon.start_animation()
		shoot_time = 0

func _process_camera():
	#Input.get_joy_axis might be between -1..1
	var new_camera_offset_x = Input.get_joy_axis(0,JOY_AXIS_2)*2 + camera.offset.x
	var new_camera_offset_y = Input.get_joy_axis(0,JOY_AXIS_3)*2 + camera.offset.y

	if (new_camera_offset_x > 0):
		new_camera_offset_x -=CAMERA_RETURNING_SPEED
	if (new_camera_offset_x < 0):
		new_camera_offset_x +=CAMERA_RETURNING_SPEED

	if (new_camera_offset_y > 0):
		new_camera_offset_y -=CAMERA_RETURNING_SPEED
	if (new_camera_offset_y < 0):
		new_camera_offset_y +=CAMERA_RETURNING_SPEED

	if ( new_camera_offset_x < CAMERA_MAX_OFFSET) and ( new_camera_offset_x > (-CAMERA_MAX_OFFSET)):
		camera.offset.x = new_camera_offset_x
	if ( new_camera_offset_y < CAMERA_MAX_OFFSET) and ( new_camera_offset_y > (-CAMERA_MAX_OFFSET)):
		camera.offset.y = new_camera_offset_y

func _physics_process(delta):
	_process_camera()
	#increment counters

	onair_time += delta
	shoot_time += delta

	if (shoot_time > cur_shooting_speed):
		shoot_time = 0
		is_shoot_ready = true

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
	if Input.is_action_pressed("ui_down"):
		target_speed = 0
	if Input.is_joy_button_pressed(0,JOY_BUTTON_2) and on_floor:
		target_speed += 4*sprite.scale.x

	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)

	if (on_floor || (current_jump_count <= jump_count)) and (Input.is_key_pressed(KEY_SPACE) || Input.is_joy_button_pressed(0,JOY_BUTTON_3)):
		linear_vel.y = -JUMP_SPEED
		current_jump_count += 1

	# Shooting
	if Input.is_joy_button_pressed(0,JOY_BUTTON_0) || Input.is_key_pressed(KEY_CONTROL):
		shot()

	if Input.is_joy_button_pressed(0,JOY_BUTTON_1):
		hit_by_hand_weapon()

	if Input.is_joy_button_pressed(0,JOY_BUTTON_6) || Input.is_key_pressed(KEY_E):
		if $forward_collision.is_colliding():
			var collider = $forward_collision.get_collider()
			if collider.get_parent() != null:
				if collider.get_parent().has_method("open"):
					if (collider.get_parent().opened == false):
						collider.get_parent().call("open")
						if (is_dialog_open):
							is_dialog_open = false
							current_dialog.queue_free()

	### ANIMATION ###

	var new_anim = "idle"

	if on_floor:
		if linear_vel.x < -SIDING_CHANGE_SPEED:
			sprite.scale.x = -1
			new_anim = "run"

		if linear_vel.x > SIDING_CHANGE_SPEED:
			sprite.scale.x = 1
			new_anim = "run"

		if Input.is_action_pressed("ui_down"):
			new_anim = "sit"

		if Input.is_joy_button_pressed(0,JOY_BUTTON_2) and on_floor:
			new_anim = "slide"

		current_jump_count = 0
	else:
		if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			sprite.scale.x = -1
		if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
			sprite.scale.x = 1

		if linear_vel.y < 0:
			new_anim = "jumping"
		else:
			new_anim = "falling"

	if new_anim != anim:
		anim = new_anim
		$anim.play(anim)


	### DIALOGS ###
	if $forward_collision.is_colliding():
		var collider = $forward_collision.get_collider()
		if collider != null :
			if collider.get_parent() != null:
				if collider.get_parent().has_method("open"):
					if (collider.get_parent().opened == false):
						if (!is_dialog_open):
							is_dialog_open = true
							current_dialog = dialog_open.instance()
							add_child(current_dialog)
	else :
		if (is_dialog_open):
			is_dialog_open = false
			current_dialog.queue_free()

func hit_by_enemy():
	count_hearts-=1
	emit_signal("player_hp_changed",count_hearts)
	if (count_hearts < 1) :
		emit_signal("player_died")

func hit_by_bullet():
	count_hearts-=1
	emit_signal("player_hp_changed",count_hearts)
	if (count_hearts < 1) :
		emit_signal("player_died")

func get_map(map):
	if (map == "map1") :
		emit_signal("player_win")

func instant_die():
	emit_signal("player_died")


