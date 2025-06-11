extends Node

func _physics_process(_delta: float) -> void:
	var player = NavdiSolePlayer.GetPlayer(self)
	player.bufs.on(player.NOLEFTBUF)
	player.vy *= 0.8
	if player.position.x > 100 or player.position.y > 100:
		player.modulate.a -= 0.01
		if player.modulate.a < 0:
			player.process_mode = Node.PROCESS_MODE_DISABLED
