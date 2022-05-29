extends CanvasLayer

func _process(_delta):
	if Input.is_action_pressed("exit"):
		_on_QuitButton_pressed()


func _on_Play_button_pressed():
	GlobalOptions.state = $Difficulty.get_selected_id()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_HowToPlayButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://interfaces/Instruction.tscn")
