extends Control


func _ready():
	$AudioStreamPlayer.play()

func _process(_delta):
	if Input.is_action_pressed("accept"):
		_on_Button_pressed()
		
func _on_Button_pressed():
	var _void = get_tree().change_scene("res://interfaces/Menu.tscn")


func _on_Timer_timeout():
	$Button.visible = true
