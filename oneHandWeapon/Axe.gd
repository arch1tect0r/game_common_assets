extends RigidBody2D

func _ready():
	pass

func start_animation():
	$anim.play("attack")


func _on_Axe_body_entered(body):
	if body.has_method("hit_by_bullet"):
		body.call("hit_by_bullet")


func _on_anim_animation_finished(anim_name):
	queue_free()
