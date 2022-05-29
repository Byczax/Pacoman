extends Node

export(PackedScene) var ghost_scene
export(PackedScene) var cookie_scene
export(PackedScene) var teleport_scene

var threads = [] # array for created threads
const threads_nr = 5 # thread count
const PACOMAN_INITIAL_POSITION = Vector2(14, 9)
var coords_for_threads = [PACOMAN_INITIAL_POSITION] # critical section with coordinates
var destination_mutex = Mutex.new() # associated with coords_for_threads

#both inclusive
const min_x = 6
const max_x = 23
const min_y = 0
const max_y = 16
const NR_BLOCKS = 70

var cookies = 0
var exit = false


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_maze(NR_BLOCKS)
	generate_points() # generates cookies to gather
	for i in range(threads_nr):
		var coords = get_coordinates() # get unique coordinates for each ghost
		coords_for_threads.append(coords) # add coordinates to critical section
		threads.append(Thread.new()) # add new thread
		threads[i].start(self, "_handle_ghost", coords) # start thread as ghost
		$Soundtrack.play()


func generate_maze(nr_blocks):
	var map = get_node("Walls")
	var rand_x
	var rand_y
	for _i in range(nr_blocks):
		for _attempts in range(5):
			while true:
				rand_x = randi()%(max_x-min_x) + min_x
				rand_y = randi()%(max_y-min_y) + min_y
				if map.get_cell(rand_x, rand_y) == -1 and Vector2(rand_x, rand_y) != PACOMAN_INITIAL_POSITION:
					break
			# now rand_x, rand_y coordinates need to be tested
			var nr_neighbours = 0
			var neighbours_coords = []
			for x in [rand_x - 1, rand_x, rand_x + 1]:
				for y in [rand_y - 1, rand_y, rand_y + 1]:
					if map.get_cell(x, y) != -1 and !(x == rand_x and y == rand_y):
						nr_neighbours += 1
						neighbours_coords.append(Vector2(x, y))
			if nr_neighbours < 2:
				map.set_cell(rand_x, rand_y, 0)
				break
			elif nr_neighbours >= 4:
				continue
			elif nr_neighbours == 2:
				if abs(neighbours_coords[0].x - neighbours_coords[1].x) == 2 or abs(neighbours_coords[0].y - neighbours_coords[1].y) == 2:
					continue
				else:
					map.set_cell(rand_x, rand_y, 0)
					break
			else: #nr_neighbours == 3
				if abs(neighbours_coords[0].x - neighbours_coords[1].x) == 2 or abs(neighbours_coords[0].y - neighbours_coords[1].y) == 2 or abs(neighbours_coords[0].x - neighbours_coords[2].x) == 2 or abs(neighbours_coords[0].y - neighbours_coords[2].y) == 2 or abs(neighbours_coords[2].x - neighbours_coords[1].x) == 2 or abs(neighbours_coords[2].y - neighbours_coords[1].y) == 2:
					continue
				else:
					map.set_cell(rand_x, rand_y, 0)
					break
			

func generate_points():
	cookies = 0
	var map = get_node("Walls")
	for i in range(min_x+1, max_x):
		for j in range (min_y+1, max_y):
			if map.get_cell(i,j) == -1 and Vector2(i,j) != PACOMAN_INITIAL_POSITION:
				cookies += 1
				var cookie = cookie_scene.instance()
				cookie.connect("point_collected", self, "decrement")
				cookie.position = get_offset(Vector2(i,j))
				add_child(cookie)


func _handle_ghost(coords):
	var ghost = ghost_scene.instance()
	ghost.position = get_offset(coords)
	
	add_child(ghost)
	var difficulty = GlobalOptions.state
	ghost.connect("player_kill", self, "_game_over")

	var new_destination = false
	var destination = ghost.position
	var teleport
	if GlobalOptions.state != 1:
		teleport = teleport_scene.instance()
		add_child(teleport)
	while(!exit):
		if GlobalOptions.state != 1:
			if new_destination:
				destination_mutex.lock() # block from other ghosts entering
				destination = get_new_destination(ghost.position) # get new coords
				destination_mutex.unlock() # allow other ghosts to enter
				teleport.position = destination
				new_destination = false
			else:
				ghost.position = destination
				new_destination = true
				
		ghost.new_direction(difficulty)
		OS.delay_msec(1000 + randi()%500)
	queue_free()

func get_coordinates():
	var map = get_node("Walls")
	var rand_x
	var rand_y
	var coords
	while(true):
		rand_x = randi()%(max_x-min_x) + min_x
		rand_y = randi()%(max_y-min_y) + min_y
		coords = Vector2(rand_x, rand_y)
		if map.get_cell(rand_x, rand_y) == -1:
			if not coords_for_threads.has(coords):
				return coords


func get_new_destination(old_coords):
	var new_coords = get_coordinates()
	coords_for_threads.erase(get_undo_offset(old_coords))
	coords_for_threads.append(new_coords)
	return get_offset(new_coords)


func get_offset(coords):
	var mult = 64
	var add = 32
	return Vector2(coords[0]*mult+add, coords[1]*mult+add)


func get_undo_offset(coords):
	var mult = 64
	var add = 32
	return Vector2((coords[0]-add)/mult, (coords[1]-add)/mult)


func decrement():
	#print(cookies)
	cookies -= 1
	if cookies == 0:
		var _void = get_tree().change_scene("res://interfaces/GameWin.tscn")


func _game_over():
	#_exit_tree()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://interfaces/GameOver.tscn")


func _exit_tree():
	exit = true
	for thread in threads:
		thread.wait_to_finish()
