extends KinematicBody2D

const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const WALK_SPEED = 70
const STATE_WALKING = 0
const STATE_KILLED = 1

onready var detect_floor_left = $detect_floor_left
onready var detect_wall_left = $detect_wall_left
onready var detect_floor_right = $detect_floor_right
onready var detect_wall_right = $detect_wall_right
onready var sprite = $sprite
onready var hit_animation = preload("res://common_assets/hit/hit_10.tscn")

var linear_velocity = Vector2()
var direction = -1
var anim=""

export var hp_count = 3
var state = STATE_WALKING


func _physics_process(delta):
	var new_anim = "idle"

	if state==STATE_WALKING:
		var slide_count = get_slide_count()
		if (slide_count > 0) :
			var collider = get_slide_collision(0).collider
			if collider != null :
				if collider.has_method("hit_by_enemy"):
					collider.call("hit_by_enemy")
					queue_free()
		
		linear_velocity += GRAVITY_VEC * delta
		linear_velocity.x = direction * WALK_SPEED
		linear_velocity = move_and_slide(linear_velocity, FLOOR_NORMAL)

		if not detect_floor_left.is_colliding() or detect_wall_left.is_colliding():
			direction = 1.0

		if not detect_floor_right.is_colliding() or detect_wall_right.is_colliding():
			direction = -1.0

		sprite.scale = Vector2(direction, 1.0)
		new_anim = "run"
	else:
		new_anim = "explode"


	if anim != new_anim:
		anim = new_anim
		$anim.play(anim)

func hit_by_player(hit_info = null):
	if (hit_info == null):
		hit_info = {}
		hit_info.hp = 1
		hit_info.position = global_position
	hp_count -= hit_info.hp
	var current_hit = hit_animation.instance()
	current_hit.position = hit_info.position
	current_hit.scale = scale
	get_parent().add_child(current_hit)
	var direction_x = 1.0
	if (global_position.x<hit_info.position.x):
		direction_x = -1.0
		
	linear_velocity.x += direction_x * 100
	if (hp_count <= 0):
		queue_free()
