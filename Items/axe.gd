extends Area2D

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

var taken=false
export var shooting_speed = 0.5

func _on_axe_body_entered(body):
	if not taken:
		if body.has_method("get_weapon"):
			body.call("get_weapon",'Axe01',shooting_speed)
			queue_free()
