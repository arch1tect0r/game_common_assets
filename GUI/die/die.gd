extends MarginContainer

signal closed_die_menu

func _ready():
	pass


func _on_TextureButton_button_up():
	emit_signal("closed_die_menu",self)
