extends RigidBody2D

var angle = 0

func _ready():
	$anim.play("shot")

func _on_life_time_timeout():
	queue_free()

func _on_timer_rotate_timeout():
	angle += 0.1
	$sprite.rotate(angle)

func _on_arcane_shot_body_entered(body):
	if body.has_method("hit_by_bullet"):
		body.call("hit_by_bullet")
	queue_free()
	
var current_scale = Vector2(1,1);	

func _add_scale(scale):
	current_scale = scale
	
func _integrate_forces(state):
	set_scale(current_scale)
	pass