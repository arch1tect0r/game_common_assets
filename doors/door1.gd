extends Node2D

func _ready():
	pass
	
var opened = false
	
func open():
	if (!opened):
		$StaticBody2D/collision.disabled = true
		$StaticBody2D/anim.play("open")
		opened = true
