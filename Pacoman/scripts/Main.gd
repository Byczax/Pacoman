extends Node

var threads = []
var threads_nr = 5 # max 10
var coords_for_threads = []
var destination_mutex = Mutex.new() # associated with coords_for_threads
#both inclusive
var min_x = 6
var max_x = 23
var min_y = 0
var max_y = 16

var speed = 75
var velocity = Vector2(1,0)
var cookies = 0
export(PackedScene) var ghost_scene
export(PackedScene) var cookie_scene
export(PackedScene) var teleport_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_points()
	for i in range(threads_nr):
		var coords = get_coordinates()
		coords_for_threads.append(coords)
		threads.append(Thread.new())
		threads[i].start(self, "_handle_ghost", coords)

func generate_points():
	var map = get_node("Walls")
	for i in range(min_x+1, max_x):
		for j in range (min_y+1, max_y):
			if map.get_cell(i,j) == -1:
				cookies += 1
				var cookie = cookie_scene.instance()
				#cookie.connect("point_collected", self, "point_decrement")
				cookie.position = get_offset(Vector2(i,j))
				add_child(cookie)

func decrement():
	pass
	
func get_offset(coords):
	var mult = 64
	var add = 32
	return Vector2(coords[0]*mult+add, coords[1]*mult+add)

func _handle_ghost(coords):
	
	#initialize
	var ghost = ghost_scene.instance()
	ghost.position = get_offset(coords)
	
	add_child(ghost)
	#var collision = ghost.move_and_collide(Vector2(1,2))
	#call_deferred("add_child", ghost)
	#ghost.move_and_slide(Vector2(1,1))
	
	#yield(get_tree().create_timer(1.0), "timeout")
	#loop
	
	var destination = ghost.position
	var teleport = teleport_scene.instance()
	add_child(teleport)
	while(true):
		#teleport.position = destination
		#TODO movment
		if destination == ghost.position:
			destination_mutex.lock()
			#print(ghost)
			destination = get_new_destination(ghost.position)
			destination_mutex.unlock()
			teleport.position = destination
		else:
			ghost.position = destination
		OS.delay_msec(500 + randi()%500)
		
		#pass

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
	#print("new:" + str(new_coords))
	return get_offset(new_coords)
	
	pass
	

func _on_point_decrement():
	print("AAAAA")
	pass # Replace with function body.
