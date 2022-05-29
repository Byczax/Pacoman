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
	$FinalTime.text = "Your time: " + _format_seconds(GlobalOptions.time, true)
	$FinalTime.visible = true
	
func _format_seconds(time : float, use_milliseconds : bool) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	if not use_milliseconds:
		return "%02d:%02d" % [minutes, seconds]
	var milliseconds := fmod(time, 1) * 100
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	
