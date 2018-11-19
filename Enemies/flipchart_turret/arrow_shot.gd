extends Area2D

var current_scale = Vector2(0.3, 0.3);

var speed = 100
var velocity = Vector2()

func _on_life_time_timeout():
	queue_free()

func start(pos, dir):
	position = pos
	rotation = dir + PI / 2.0
	velocity = Vector2(speed, 0).rotated(dir)

func _add_scale(scale):
	current_scale = scale
	set_scale(current_scale)

func _integrate_forces(state):
	set_scale(current_scale)

func _physics_process(delta):
	position += velocity * delta

func _on_arrow_shot_body_entered(body):
	if body.has_method("hit_by_bullet"):
		body.call("hit_by_bullet")
		queue_free()
