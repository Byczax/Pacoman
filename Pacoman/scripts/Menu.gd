extends CanvasLayer

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()

func _on_Play_button_pressed():
	get_tree().change_scene("res://Main.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
