extends Node2D

@export var maze : Maze
var cell : Vector2i
var celloffset : Vector2

var curdir = -1
var held_dpad = null
var turn_dpad = null

func _ready() -> void:
	cell = maze.local_to_map(position)
	celloffset = maze.map_to_center(cell) - position

const DIRS = [Vector2i.RIGHT, Vector2i.UP, Vector2i.LEFT, Vector2i.DOWN]

func try_move(dir:Vector2i) -> bool:
	if dir.y:
		if abs(celloffset.x)>5: return false
		if dir.y > 0 and celloffset.y < 0: return false
		if dir.y < 0 and celloffset.y > 0: return false
	if dir.x:
		if abs(celloffset.y)>5: return false
		if dir.x > 0 and celloffset.x < 0: return false
		if dir.x < 0 and celloffset.x > 0: return false
	
	if maze.get_cell_tid(cell+dir)<0:
		cell+=dir
		celloffset-=(dir as Vector2)*10
		if dir.x:
			$spr.flip_h = dir.x<0
			$spr.rotation = 0
		elif $spr.flip_h == (dir.y<0):
			$spr.rotation = PI * 0.5
		else:
			$spr.rotation = PI * -0.5
		return true
	return false # else:

func queue_dir(dir : Vector2i) -> void:
	if!held_dpad or (held_dpad.x==0)==(dir.x==0):
		held_dpad = dir
		turn_dpad = null
	else:
		turn_dpad = dir

func _physics_process(_delta: float) -> void:
	var dpad_tap = Pin.get_dpad_tap()
	if dpad_tap.y:
		queue_dir(Vector2i(0,dpad_tap.y))
	if dpad_tap.x:
		queue_dir(Vector2i(dpad_tap.x,0))
	if turn_dpad and try_move(turn_dpad):
		held_dpad = turn_dpad
		turn_dpad = null
	if held_dpad: try_move(held_dpad)
	
	if celloffset:
		celloffset.x = move_toward(celloffset.x, 0, 1)
		celloffset.y = move_toward(celloffset.y, 0, 1)
		$spr.setup([11,12],7)
	else:
		$spr.playing = false
	position = maze.map_to_local(cell) + celloffset
