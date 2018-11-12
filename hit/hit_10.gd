extends Node2D

func _ready():
	$anim.play("anim")


func _on_anim_animation_finished(anim_name):
	if (anim_name == "anim"):
		queue_free()
