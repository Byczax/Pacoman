extends CanvasLayer

signal start_game
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_StartButton_pressed():
	$StartButton.hide()
	$MaxScore.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Message.hide()

func _on_Play_button_pressed():
	$PlayButton.hide()
	$ColorRect.hide()
	$Title.hide()

	emit_signal("start_game")
	pass # Replace with function body.
