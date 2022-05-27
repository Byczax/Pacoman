extends Node

var threads = [] # array for created threads
var threads_nr = 5 # thread count
var coords_for_threads = [Vector2(14, 9)] # critical section with coordinates
var destination_mutex = Mutex.new() # associated with coords_for_threads
#both inclusive
var min_x = 6
var max_x = 23
var min_y = 0
var max_y = 16

var speed = 75
var velocity = Vector2(1,0)
var cookies = 0
var exit = false
export(PackedScene) var ghost_scene
export(PackedScene) var cookie_scene
export(PackedScene) var teleport_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_points()
	for i in range(threads_nr):
		var coords = get_coordinates() # get unique coordinates for each ghost
		coords_for_threads.append(coords) # add coordinates to critical section
		threads.append(Thread.new()) # add new thread
		threads[i].start(self, "_handle_ghost", coords) # start thread as ghost

func generate_points():
	var map = get_node("Walls")
	for i in range(min_x+1, max_x,5):
		for j in range (min_y+1, max_y,5):
			if map.get_cell(i,j) == -1:
				cookies += 1
				var cookie = cookie_scene.instance()
				cookie.connect("point_collected", self, "decrement")
				cookie.position = get_offset(Vector2(i,j))
				add_child(cookie)

func decrement():
	print(cookies)
	cookies -= 1
	if cookies == 0:
		var _void = get_tree().change_scene("res://GameWin.tscn")
	pass
	
func get_offset(coords):
	var mult = 64
	var add = 32
	return Vector2(coords[0]*mult+add, coords[1]*mult+add)
	
func get_undo_offset(coords):
	var mult = 64
	var add = 32
	return Vector2((coords[0]-add)/mult, (coords[1]-add)/mult)

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
	while(!exit):
		#teleport.position = destination
		#TODO movment
		if destination == ghost.position:
			destination_mutex.lock() # block from other ghosts entering
			destination = get_new_destination(ghost.position) # get new coords
			destination_mutex.unlock() # allow other ghosts to enter
			teleport.position = destination
		else:
			ghost.position = destination
			
		OS.delay_msec(500 + randi()%500)
		

func get_coordinates():
	var map = get_node("Walls")
	var rand_x
	var rand_y
	var coords
	while(true):
		rand_x = randi()%(max_x-min_x) + min_x
		rand_y = randi()%(max_y-min_y) + min_y
		coords = Vector2(rand_x, rand_y)
		#print(coords)
		if map.get_cell(rand_x, rand_y) == -1:
			if not coords_for_threads.has(coords):
				return coords

func _exit_tree():
	exit = true
	for thread in threads:
		thread.wait_to_finish()
#	pass
	
func get_new_destination(old_coords):
	var new_coords = get_coordinates()
	coords_for_threads.erase(get_undo_offset(old_coords))
	coords_for_threads.append(new_coords)
	return get_offset(new_coords)
