extends Area2D

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

var taken=false

func _on_bullet_body_entered(body):
	if not taken:
		if body.has_method("get_weapon"):
			body.call("get_weapon",'bullet',0.1)
			queue_free()

var current_scale = Vector2(1,1);	

func _add_scale(scale):
	current_scale = scale
	sprite.set_scale(current_scale)
	
func _integrate_forces(state):
	sprite.set_scale(current_scale)
	pass