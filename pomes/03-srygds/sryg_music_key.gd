extends Node
class_name SrygMusicKey

@export var track : int = -1
func _ready() -> void:
	SrygSounds.GetSS().set_track(track)
