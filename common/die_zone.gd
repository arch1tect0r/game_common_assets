extends Node2D

func _ready():
	pass

func _on_die_zone_body_entered(body):
	if (body != null):
		if (body.has_method("instant_die")):
			body.call("instant_die")
		else:
			body.queue_free()
