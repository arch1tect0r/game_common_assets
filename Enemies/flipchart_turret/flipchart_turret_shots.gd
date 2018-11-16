extends StaticBody2D

export (float) var hp = 5
export (int) var detect_radius = 100  # size of the visibility circle
export (float) var fire_rate = 2 # count of bullets in second

onready var arrow = preload("res://common_assets/Enemies/flipchart_turret/arrow_shot.tscn")
onready var hit_animation = preload("res://common_assets/hit/hit_10.tscn")

var target = null
#var prepared_arrow = null
var can_prepare_arrow = true
var detection_area_color = Color(.867, .91, .247, 0.1)
var laser_color = Color(.80, .91, .247, 0.1)
var hit_pos

func _ready():
	var shape = CircleShape2D.new()
	shape.radius = detect_radius
	$visibility/collision_visibility.shape = shape
	$allow_arrow.wait_time = 1.0 / fire_rate

func _physics_process(delta):
	update()

	if target:
		aim()

func aim():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, target.position, [self], collision_mask)
	if result:
		hit_pos = result.position
		if result.collider.name == 'Mark':
			# angle in radians
			$arrow.rotation = (target.position - position).angle() + PI / 2.0
			if can_prepare_arrow:
				shoot(target.position)


func shoot(pos):
	var new_arrow = arrow.instance()
	var arrow_angle = (pos - global_position).angle()
	new_arrow.start(global_position, arrow_angle + rand_range(-0.05, 0.05))
	get_parent().add_child(new_arrow)
	can_prepare_arrow = false
	$allow_arrow.start()

func _draw():
	# display the visibility area
	draw_circle(Vector2(), detect_radius, detection_area_color)
#	if target:
#		draw_line(Vector2(), hit_pos - position, laser_color)
#		draw_circle(hit_pos - position, 2, laser_color)

func hit_by_player(hit_info = null):
	if (hit_info == null):
		hit_info = {}
		hit_info.hp = 1
		hit_info.position = global_position

	hp -= hit_info.hp

	var current_hit = hit_animation.instance()
	current_hit.position = hit_info.position
	current_hit.scale = scale
	get_parent().add_child(current_hit)

	if (hp <= 0):
#		explosion._on_animate()
		$sprite.visible = false
#		$find_collision.disabled = true
		queue_free()

func _on_allow_arrow_timeout():
	$allow_arrow.stop()
	can_prepare_arrow = true

func _on_visibility_body_entered(body):
	if target:
		return

	if body.name == "Mark":
		target = body
		$arrow.visible = true


func _on_visibility_body_exited(body):
	if body == target:
		target = null
		$arrow.visible = false
