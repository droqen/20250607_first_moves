extends Node2D
func _ready() -> void:
	modulate.a = 0
func _physics_process(_delta: float) -> void:
	var player = NavdiSolePlayer.GetPlayer(self)
	if player:
		if modulate.a < 1:
			modulate.a += 0.01
		position = lerp(position, player.position, 0.2)
	else:
		if modulate.a > 0:
			modulate.a -= 0.01
		position = lerp(position, player.position + Vector2.DOWN * 30, 0.2)
