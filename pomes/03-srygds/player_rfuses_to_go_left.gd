extends Node

func _physics_process(_delta: float) -> void:
	var player = NavdiSolePlayer.GetPlayer(self)
	if player:
		if player.position.x < 200 and player.vx < 0:
			player.vx *= player.position.x / 200.0
		if player.position.x < 100:
			player.bufs.on(player.NOLEFTBUF)
