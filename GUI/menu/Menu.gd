extends MarginContainer

signal open_level
var current_level=1

var level1 = preload("res://level1/Level1.tscn")
var level0 = preload("res://level0/Level0_dungeon.tscn")

func _on_StartButton_pressed():
	pass

func player_died(level):
	level.queue_free()
	self.visible = true

func _on_StartButton_button_up():
	emit_signal("open_level", "Level1", self)


func _on_StartButton0_button_up():
	emit_signal("open_level", "Level0", self)
