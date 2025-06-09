extends Node

@onready var maze : Maze = get_parent()

func _physics_process(_delta: float) -> void:
	if randf() < 0.02 : maze.set_cell_tid(Vector2i(randi()%32,randi()%9), 16)
	if randf() < 0.001 : for blucell in maze.get_used_cells_by_tids([16]):
		maze.set_cell_tid(blucell, -1)
