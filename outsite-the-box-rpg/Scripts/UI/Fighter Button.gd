extends CustomButton

var fighter : ActiveFighter


func get_fighter(_fighter : ActiveFighter):
	fighter = _fighter
	pass


func on_focus():
	pass_on_focus.emit(fighter)
	pass


func _pressed():
	if fighter.alignment == ActiveFighter.Alignment.enemy:
		pass_on_press.connect($"/root/Battle/Battle Manager".assign_target)
		pass_on_press.emit(fighter)
	pass
