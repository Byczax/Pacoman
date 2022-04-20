extends Area2D


var thread
var thread2

# Called when the node enters the scene tree for the first time.
func _ready():
	thread = Thread.new()
	thread2 = Thread.new()
	thread.start(self, "_thread_function", "Speeeed1")
	thread2.start(self, "_thread_function", "Speeeed2")
	pass # Replace with function body.

func _thread_function(userdata):
	# Print the userdata ("Wafflecopter")
	print("I'm a thread! Userdata is: ", userdata)
	
func _exit_tree():
	thread.wait_to_finish()
	thread2.wait_to_finish()
