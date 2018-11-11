extends RigidBody2D

#func _on_Timer_timeout():
#	$anim.play("shutdown")

var angle = 0
onready var sprite = $sprite

func _on_Timer_timeout():
	angle += 0.2
	#sprite.rotate(angle)

func _on_life_time_timeout():
	queue_free()


func _on_axe_body_entered(body):
	if body.has_method("hit_by_bullet"):
		body.call("hit_by_bullet")
		queue_free()
	##
	
	
var current_scale = Vector2(1,1);	

func _add_scale(scale):
	current_scale = scale
	set_scale(current_scale)
	
func _integrate_forces(state):
	set_scale(current_scale)
	pass