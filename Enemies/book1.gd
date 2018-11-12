extends KinematicBody2D

var BULLET_VELOCITY = 100

onready var collision1 = $player_find_collision
onready var collision2 = $player_find_collision2
onready var collision3 = $player_find_collision3
onready var collision4 = $player_find_collision4
onready var hit_animation = preload("res://common_assets/hit/hit_10.tscn")
onready var shot = preload("res://common_assets/Bullets/arcane_shot.tscn")

var collisions = Array()
var linear_velocity = Vector2()
onready var explosion = $explosion

var angle = 0
var is_shoot_ready = true
var current_animation = "stop"

export var hp_count = 3

func _on_player_find_timer_timeout():
	for item in collisions :
		if (item.is_colliding()):
			var collider = item.get_collider()
			if (collider != null):
				try_shot(collider,item)
		item.rotation_degrees += 1
		
func shot(collider,item):
	if (is_shoot_ready):
		var current_shot = shot.instance()
		current_shot.position = $sprite.global_position
		
		var x_acceleration = (collider.global_position.x - $sprite.global_position.x)		
		var y_acceleration = (collider.global_position.y - $sprite.global_position.y) 
		linear_velocity = Vector2( x_acceleration*0.5, y_acceleration*0.5)
		
		current_shot.linear_velocity = Vector2( x_acceleration, y_acceleration)
		current_shot.gravity_scale = 0
		current_shot.add_collision_exception_with(self) 
		current_shot._add_scale(scale*0.5)
		get_parent().add_child(current_shot) 
		#$sound_shoot.play()
		is_shoot_ready = false
		$shooting_speed.start()

func try_shot(collider,item):
	if (collider.has_method("hit_by_enemy")):
		if current_animation == "stop" :
			current_animation = "attack"
			$anim.play(current_animation)
		var linear_velocity = Vector2(collider.global_position.x,collider.global_position.y)
		shot(collider,item)

func _ready():
	collisions.push_back(collision1)
	collisions.push_back(collision2)
	collisions.push_back(collision3)
	collisions.push_back(collision4)
	explosion.connect("animation_ended",self,"_on_free")
	explosion._add_scale(scale*0.5)
	
func _physics_process(delta):
	linear_velocity = move_and_slide(linear_velocity, Vector2(0, -1))	

func _on_shooting_speed_timeout():
	is_shoot_ready = true

func _on_anim_animation_finished(anim_name):
	current_animation = "stop"
	
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
		explosion._on_animate()
		$sprite.visible = false
		$collision.disabled = true
		queue_free()
	
func _on_free():
	queue_free()
