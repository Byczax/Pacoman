extends KinematicBody2D

#var speed = 750
var velocity = Vector2(0,0)
var speed = 100
var difficulty


func set_difficulty(level):
	difficulty = level

func new_direction():
	if difficulty != 0:
		velocity = Vector2(speed, (randi()%360))
	
#func start(pos, dir):
#	rotation = dir
#	position = pos
#	velocity = Vector2(speed, 0).rotated(rotation)

#func _physics_process(delta):
#	var collision = move_and_collide(velocity * delta)
#	if collision:
#		velocity = velocity.bounce(collision.normal)
#		if collision.collider.has_method("hit"):
#			collision.collider.hit()

#func _on_VisibilityNotifier2D_screen_exited():
#	queue_free()
func _process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.name == "Player":
			var _value = get_tree().change_scene("res://GameOver.tscn")
		velocity = velocity.bounce(collision.normal)
		#print("I collided with ", collision.collider.name)
	
	#	velocity =
#func _on_body_entered(body):
#	if body.name == "Player":
#		get_tree().change_scene("res://GameOver.tscn")
#		print("AAAAAAAAA")
#		pass # Replace with function body.


func _on_Button_pressed():
	get_tree().change_scene("res://Menu.tscn")
