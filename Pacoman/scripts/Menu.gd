extends CanvasLayer

#func _ready():
#	pass # Replace with function body.
var difficulty = 0
func _process(_delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()

func _on_Play_button_pressed():
	GlobalOptions.state = $Difficulty.get_selected_id()
	#difficulty = $Difficulty.get_selected_id()
	var _value = get_tree().change_scene("res://Main.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
