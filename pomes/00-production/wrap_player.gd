extends Node
@export var player : Node2D
func _physics_process(_delta: float) -> void:
	if player:
		match player.side:
			0:
				if player.position.x > 130-3 and player.position.x < 140:
					player.position.x += 10
					player.side = 1
				if player.position.x < 0+3:
					player.position.x += 320
					player.side = 1
			1:
				if player.position.x > 130 and player.position.x < 140+3:
					player.position.x -= 10
					player.side = 0
				if player.position.x > 320-3:
					player.position.x -= 320
					player.side = 0
	if player.position.x > 170 and player.position.x < 200 and player.position.y > 150:
		player.vx_control_locked = true
	if player.position.y > 190:
		get_parent().stage_cleared.emit()
