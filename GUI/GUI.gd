extends MarginContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

export var hp_count = 3

func deacrease_hp():
	if hp_count == 3 :
		$HBoxContainer/hp3.visible = false
	if hp_count == 2 :
		$HBoxContainer/hp2.visible = false
	if hp_count == 1 :
		$HBoxContainer/hp1.visible = false
	hp_count = hp_count - 1
	