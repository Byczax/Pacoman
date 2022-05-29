extends KinematicBody2D

signal player_kill

var velocity = Vector2(0,0)


func new_direction(difficulty):
	if difficulty != 0:
		velocity = Vector2(100, (randi()%360))


func _process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.name == "Player":
			emit_signal("player_kill")
		velocity = velocity.bounce(collision.normal)


func _on_Button_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://interfaces/Menu.tscn")
