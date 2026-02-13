extends Control

func _on_accelerate_button_down():
	MobileInput.accelerate = true

func _on_accelerate_button_up():
	MobileInput.accelerate = false

func _on_brake_button_down():
	MobileInput.brake = true

func _on_brake_button_up():
	MobileInput.brake = false

func _on_interact_button_down():
	MobileInput.interact = true

func _on_interact_button_up():
	MobileInput.interact = false
