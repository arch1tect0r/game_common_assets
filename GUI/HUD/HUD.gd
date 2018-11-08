extends MarginContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():	
	get_parent().connect("player_hp_changed",self,"player_hp_changed")

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
	

func _on_Mark_player_hp_changed(hp):
	if (hp < hp_count) :
		var i = hp
		while (i < hp_count) :
			if i == 3 :
				$CanvasLayer/VBoxContainer/HBoxContainer/hp3.visible = false
			if i == 2 :
				$CanvasLayer/VBoxContainer/HBoxContainer/hp2.visible = false
			if i == 1 :
				$CanvasLayer/VBoxContainer/HBoxContainer/hp1.visible = false
			hp_count-=1
	hp_count = hp
