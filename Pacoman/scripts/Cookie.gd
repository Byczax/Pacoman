extends Area2D

signal point_collected


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#	pass


func _on_body_entered(body):
	if body.name == "Player":
		#signal_bus.emit_signal("on_connect")
		emit_signal("point_collected")
		#print("OoO")
		$EatSound.play()
		anim_player.play("fade_out")
	#pass # Replace with function body.


func _on_point_collected():
	#print("UwU")
	pass
	#pass # Replace with function body.
