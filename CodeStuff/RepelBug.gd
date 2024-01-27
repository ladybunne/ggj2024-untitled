extends BugEntity


func _on_yelling_timer_timeout():
	hide_yell()
	
func _on_between_yelling_timer_timeout():
	show_yell()

func show_yell():
	var label = get_parent().get_node("YellingLabel")
	label.visible = true
	var yelling_timer: Timer = get_node("YellingTimer")
	yelling_timer.start()

func hide_yell():
	var label = get_parent().get_node("YellingLabel")
	label.visible = false
	var between_yelling_timer: Timer = get_node("BetweenYellingTimer")
	between_yelling_timer.start()
