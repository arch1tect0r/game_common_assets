extends RigidBody2D

const ROTATE_DELAY = 0.3
const LIFE_TIME = 2.0

onready var anim = $anim

var time = 0.0
var general_time = 0.0

func _ready():
	anim.play("anim")
	pass
	
func _physics_process(delta):
	time += delta
	general_time += delta
	if (time > ROTATE_DELAY):
		time = 0
		#rotate(5)
	if (general_time > LIFE_TIME):
		queue_free()


func _on_10_body_entered(body):
	if body.has_method("hit_by_player"):
		var hit_info = {}
		hit_info.position = global_position
		hit_info.hp = 1
		body.call("hit_by_player",hit_info)
		queue_free()
		
var current_scale = Vector2(1,1);	

func _add_scale(scale):
	current_scale = scale
	set_scale(current_scale)
	
func _integrate_forces(state):
	set_scale(current_scale)
	pass
