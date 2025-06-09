extends Node

@onready var main = get_parent()
@onready var stage_container = $"../StageContainer"
func _ready() -> void:
	goto_stage("res://pomes/02-eyeservant/02_start.tscn")
	#await current_stage.stage_cleared
	#null_stage()
	#await get_tree().create_timer(0.33).timeout
	#goto_stage("res://pomes/00-production/production_2.tscn")
	#await current_stage.stage_cleared
	#null_stage()

var current_stage : Stage = null

func null_stage() -> void:
	for child in stage_container.get_children():
		child.name = "(deleted)"
		child.queue_free()
	current_stage = null

func goto_stage(stage_scene_path : String) -> void:
	null_stage()
	current_stage = load(stage_scene_path).instantiate()
	stage_container.add_child(current_stage)
	current_stage.owner = stage_container.owner if stage_container.owner else stage_container
