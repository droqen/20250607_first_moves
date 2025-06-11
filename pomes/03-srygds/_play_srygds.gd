extends Node

@onready var main = get_parent()
func _ready() -> void:
	await get_tree().physics_frame
	goto_stage("res://pomes/03-srygds/srygds_start.tscn")
	#await current_stage.stage_cleared
	#null_stage()
	#await get_tree().create_timer(0.33).timeout
	#goto_stage("res://pomes/00-production/production_2.tscn")
	#await current_stage.stage_cleared
	#null_stage()

var current_stage : Stage = null

func null_stage() -> void:
	for child in main.stage_container.get_children():
		child.name = "(deleted)"
		child.queue_free()
	current_stage = null

func goto_stage(stage_scene_path : String) -> void:
	null_stage()
	current_stage = load(stage_scene_path).instantiate()
	main.stage_container.add_child(current_stage)
	current_stage.owner = main.owner if main.owner else main
