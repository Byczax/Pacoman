extends Area2D

signal point_collected


onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")


func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("point_collected")
		$EatSound.play()
		anim_player.play("fade_out")
