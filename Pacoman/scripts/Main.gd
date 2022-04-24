extends Node

var threads = []
var threads_nr = 10 # max 10
var coords_for_threads = []
var destination_mutex = Mutex.new() # associated with coords_for_threads
#both inclusive
var min_x = 6
var max_x = 23
var min_y = 0
var max_y = 16

export(PackedScene) var ghost_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for i in range(threads_nr):
		var coords = get_coordinates()
		coords_for_threads.append(coords)
		threads.append(Thread.new())
		threads[i].start(self, "_handle_ghost", coords)

func get_offset(coords):
	var mult = 64
	var add = 32
	return Vector2(coords[0]*mult+add, coords[1]*mult+add)

func _handle_ghost(coords):
	
	#initialize
	var ghost = ghost_scene.instance()
	ghost.position = get_offset(coords)
	add_child(ghost)
	#call_deferred("add_child", ghost)
	#ghost.move_and_slide(Vector2(1,1))
	
	#yield(get_tree().create_timer(1.0), "timeout")
	#loop
	
	var destination = ghost.position
	while(true):
		if destination == ghost.position:
			destination_mutex.lock()
			print(ghost)
			destination = get_new_destination(ghost.position)
			destination_mutex.unlock()
		pass

func get_coordinates():
	var map = get_node("Walls")
	var rand_x = randi()%(max_x-min_x) + min_x
	var rand_y = randi()%(max_y-min_y) + min_y
	var coords = Vector2(rand_x, rand_y)
	if map.get_cell(rand_x, rand_y) == -1:
		if not coords_for_threads.has(coords):
			return coords
	return get_coordinates()

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _exit_tree():
	#for thread in threads:
	#	thread.wait_to_finish()
	pass
	
func get_new_destination(old_coords):
	var new_coords = get_coordinates()
	coords_for_threads.erase(old_coords)
	coords_for_threads.append(new_coords)
	print("new:" + str(new_coords))
	return new_coords
	
	pass
	
	
	


	
