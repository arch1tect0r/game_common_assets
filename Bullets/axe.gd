extends RigidBody2D

#func _on_Timer_timeout():
#	$anim.play("shutdown")

var angle = 0

func _on_Timer_timeout():
	angle += 0.2
	$Sprite.rotate(angle)

func _on_life_time_timeout():
	queue_free()


func _on_axe_body_entered(body):
	if body.has_method("hit_by_bullet"):
		body.call("hit_by_bullet")
