extends Node2D

@export var front_thoughts : Array[String]

func _ready() -> void:
	modulate.a = 0
	var player = NavdiSolePlayer.GetPlayer(self)
	player.front_thoughts = front_thoughts
func _physics_process(_delta: float) -> void:
	var player = NavdiSolePlayer.GetPlayer(self)
	if player and !player.voiceless:
		if modulate.a < 1:
			modulate.a += 0.01
		position = lerp(position, player.position, 0.2)
	else:
		if player and player.voiceless: $backthoughts.shhh()
		if modulate.a > 0:
			modulate.a -= 0.01
		position = lerp(position, player.position + Vector2.DOWN * 30 * (1-modulate.a), 0.2)
func _exit_tree() -> void:
	var player = NavdiSolePlayer.GetPlayer(self)
	if player and player.front_thoughts == front_thoughts:
		player.front_thoughts = [] as Array[String]
