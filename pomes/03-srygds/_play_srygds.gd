extends Node

@onready var main = get_parent()
func _ready() -> void:
	await get_tree().physics_frame
	goto_stage("res://pomes/03-srygds/srygds_start.tscn", Vector2i.ZERO)
	#goto_stage("res://pomes/03-srygds/srygds_return.tscn", Vector2i.ZERO)
	#await current_stage.stage_cleared
	#null_stage()
	#await get_tree().create_timer(0.33).timeout
	#goto_stage("res://pomes/00-production/production_2.tscn")
	#await current_stage.stage_cleared
	#null_stage()

var camvel : Vector2

func _physics_process(delta: float) -> void:
	camvel = lerp(camvel, -main.camera_offset, 0.001) * 0.99
	var goal_camvel : Vector2 = -main.camera_offset * 0.05
	camvel *= 0.95
	camvel = lerp(camvel, goal_camvel, 0.02)
	camvel += (goal_camvel - camvel).limit_length(0.005)
	main.camera_offset += camvel
	if previous_stages:
		var erase_stages = []
		for stage in previous_stages:
			stage.modulate.a -= delta
			if stage.modulate.a <= 0:
				erase_stages.append(stage)
		for stage in erase_stages:
			previous_stages.erase(stage)
			main.stage_container.remove_child(stage)
	if current_stage:
		if current_stage.modulate.a < 1:
			current_stage.modulate.a += delta
		var player = NavdiSolePlayer.GetPlayer(self)
		if player:
			if player.position.x < 0:
				goto_stage(
					current_stage.stage_left,
					Vector2i.LEFT
				)
			if player.position.x >= current_stage.width:
				goto_stage(
					current_stage.stage_right,
					Vector2i.RIGHT
				)
			if current_stage.no_stage_up_allowed:
				pass
			elif player.position.y < 0:
				goto_stage(
					current_stage.stage_up,
					Vector2i.UP
				)
			if player.position.y >= current_stage.height:
				goto_stage(
					current_stage.stage_down,
					Vector2i.DOWN
				)

var previous_stages: Array[Stage] = []
var current_stage : Stage = null
var current_stage_path : String

func goto_stage(stage_scene_path : String, dir : Vector2i) -> void:
	var prev_stage = current_stage
	if stage_scene_path: current_stage_path = stage_scene_path
	current_stage = load(current_stage_path).instantiate()
	current_stage.modulate.a = 0.0 # fade in
	main.stage_container.add_child(current_stage)
	main.stage_container.move_child(current_stage, 0)
	current_stage.owner = main.owner if main.owner else main
	
	var move : Vector2 = -Vector2(
		dir.x * current_stage.width,
		dir.y * current_stage.height
	)
	
	if prev_stage:
		prev_stage.process_mode = Node.PROCESS_MODE_DISABLED
		previous_stages.append(prev_stage)
		for child in prev_stage.get_children():
			if child is Maze:
				(child as Maze).collision_enabled = false
	for stage in previous_stages:
		stage.position += move;
	var player = NavdiSolePlayer.GetPlayer(self)
	if player:
		player.position += move;
	main.camera_offset += move;
