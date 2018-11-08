extends MarginContainer

var default_texture_path = "res://common_assets/Items/assets/"

func _ready():	
	$CanvasLayer/VBoxContainer/HBoxContainer2/current_weapon.texture = load(default_texture_path+"bullet.PNG")

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


func _on_Mark_player_weapon_changed(new_weapon):
	$CanvasLayer/VBoxContainer/HBoxContainer2/current_weapon.texture = load(default_texture_path+new_weapon+".PNG")
