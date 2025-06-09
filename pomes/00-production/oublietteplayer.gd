extends Node2D

var initialfall : bool = true
var initialfall_timer : int = 8

func _physics_process(_delta: float) -> void:
	if initialfall:
		if initialfall_timer < 15:
			initialfall_timer += 1
		else:
			initialfall_timer = 0
			if position.y > 190: get_parent().stage_cleared.emit()
			position.y += 10
			$spr.flip_h = !$spr.flip_h
	#var dpad = Pin.get_dpad()
