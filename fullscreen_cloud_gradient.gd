@tool
extends TextureRect

@export var fastnoise : FastNoiseLite

func _physics_process(delta: float) -> void:
	if fastnoise:
		fastnoise.offset.x += delta * 100
		if fastnoise.offset.x > 10000:
			fastnoise.offset.x = 0
