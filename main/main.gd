extends Node2D
@onready var camera = $Camera2D
@onready var stage_container = $StageContainer
func _physics_process(_delta: float) -> void:
	if stage_container.get_child_count() > 0:
		var stage : Stage = stage_container.get_child(0)
		var viewportsize : Vector2i = get_viewport_rect().size
		var pxscale : int = mini(viewportsize.x / stage.width, viewportsize.y / stage.height)
		if pxscale < 1: pxscale = 1
		camera.zoom = Vector2.ONE * pxscale
		camera.position.x = stage.width/2
		camera.position.y = stage.height/2
		var size = viewportsize / pxscale + Vector2i(10,10)
		$bg.position = camera.position - size * 0.5
		$bg.size = size
		$bg.color = stage.bgcol
