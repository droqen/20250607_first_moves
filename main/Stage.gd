@tool
class_name Stage
extends Node2D
signal stage_cleared
@export var width : int = 100
@export var height : int = 100
@export var bordercol : Color = Color.BLACK
@export var bgcol : Color = Color.WEB_GRAY
@export var filter : TextureFilter = TEXTURE_FILTER_NEAREST

@export_file("*.tscn") var stage_left: String
@export_file("*.tscn") var stage_right: String
@export_file("*.tscn") var stage_up: String
@export_file("*.tscn") var stage_down: String
@export var no_stage_up_allowed : bool = false

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(Rect2(0,0,width,height), bordercol, false, 2.0)
func _ready() -> void:
	texture_filter = filter
	if Engine.is_editor_hint():
		ProjectSettings.set("rendering/environment/defaults/default_clear_color", bgcol)
	else:
		RenderingServer.set_default_clear_color(bgcol)
