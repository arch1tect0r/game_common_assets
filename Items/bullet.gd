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
