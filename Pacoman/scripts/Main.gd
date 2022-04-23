extends Node2D

var threads = []
var threads_nr = 2

#both inclusive
var min_x = 6
var max_x = 20
var min_y = 0
var max_y = 14

export(PackedScene) var ghost_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var coords_for_threads = []
	for i in range(threads_nr):
		var coords = get_coordinates()
		while coords_for_threads.has(coords):
			coords = get_coordinates()
		coords_for_threads.append(coords)
		threads.append(Thread.new())
		threads[i].start(self, "handle_ghost", coords)
		
	#for thread in threads:
	#	thread.start(self, "handle_ghost")
	
	#get_coordinates()
	

func handle_ghost(coords):
	#var coords = get_coordinates()
	print(coords)
	var ghost = ghost_scene.instance()
	ghost.position = coords
	print(ghost.position)
	#call_deferred("add_child", child_node)
	#loop
	pass

func get_coordinates():
	var map = get_node("Walls")
	var rand_x = randi()%(max_x-min_x) + min_x
	var rand_y = randi()%(max_y-min_y) + min_y
	if map.get_cell(rand_x, rand_y) == -1:
		return [rand_x, rand_y]
	else:
		return get_coordinates()
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Menu_start_game():
	$Player.start($StartPosition.position)
	pass # Replace with function body.
