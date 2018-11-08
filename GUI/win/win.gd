extends MarginContainer

signal closed_win_menu

func _ready():
	pass


func _on_TextureButton_button_up():
	emit_signal("closed_win_menu",self)
