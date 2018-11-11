extends RigidBody2D

func _on_bullet_body_enter( body ):
	if body.has_method("hit_by_bullet"):
		body.call("hit_by_bullet")
		queue_free()

func _on_Timer_timeout():
	$anim.play("shutdown")
	
var current_scale = Vector2(1,1);	

func _add_scale(scale):
	set_scale(scale)
	current_scale = scale
	
func _integrate_forces(state):
	set_scale(current_scale)
	pass