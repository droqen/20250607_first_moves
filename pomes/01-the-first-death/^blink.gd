extends Node
var numbrindex : int = -1
var numtimer : int = 0
var numbers = [
	40049,
	40144,
	42195,
	42599,
	45443,
	46442,
	48930,
	49000,
	49102,
]

func _physics_process(_delta: float) -> void:
	if numtimer == 0 or numtimer >= 90:
		numbrindex = (numbrindex + 1) % len(numbers)
		get_parent().text = str(numbers[numbrindex])
		numtimer = 0
	if numtimer == 70:
		get_parent().text = ''
	numtimer += 1
