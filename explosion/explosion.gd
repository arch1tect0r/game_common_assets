extends Node2D

signal animation_ended

onready var anim = $anim
onready var sprite = $sprite

func _ready():
	pass

func _on_animate():
	sprite.scale = get_parent().scale
	anim.play("explosion")

func _on_anim_animation_finished(anim_name):
	emit_signal("animation_ended")
	
var current_scale = Vector2(1,1);	

func _add_scale(scale):
	current_scale = scale
	
func _integrate_forces(state):
	set_scale(current_scale)
	pass