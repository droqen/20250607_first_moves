extends Node2D

var vx_control_locked : bool = false
var vx : float
var vy : float
enum {FLORBUF,JUMPBUF,FLCKRBUF}
@onready var bufs : Bufs = Bufs.Make(self).setup_bufons([
	FLORBUF,4,JUMPBUF,4,FLCKRBUF,2
])
var vx_apply_step_flckring : int = 0
var vy_apply_step : int = 0
var _side : int = 0
var side : int :
	get() : return _side
	set(v) :
		_side = v
		bufs.on(FLCKRBUF)

func _physics_process(_delta: float) -> void:
	var jumphit = Pin.get_jump_hit()
	var jumpheld = Pin.get_jump_held()
	var dpad = Pin.get_dpad()
	if vx_control_locked: dpad.x = 0
	if dpad.x: $spr.flip_h = dpad.x < 0
	vx = dpad.x
	vy = move_toward(vy, 3.0, 0.1)
	if jumphit: bufs.on(JUMPBUF)
	var onfloor = $mover.cast_fraction(self, $mover/solidcast, VERTICAL, 1) < 1
	if onfloor: bufs.on(FLORBUF)
	if vx:
		if bufs.has(FLCKRBUF) and vx_apply_step_flckring < 3:
			vx_apply_step_flckring += 1
		else:
			if !$mover.try_slip_move(self, $mover/solidcast, HORIZONTAL, vx):
				vx = 0
			vx_apply_step_flckring = 0
	if vy:
		if vy_apply_step > 0:
			vy_apply_step -= 1
		else:
			if !$mover.try_slip_move(self, $mover/solidcast, VERTICAL, vy):
				vy = 0
				vy_apply_step = 0
			else:
				vy_apply_step = 3
	if bufs.try_eat([JUMPBUF,FLORBUF]):
		onfloor = false
		vy = -3.0
		vy_apply_step = 0
	if not bufs.has(FLCKRBUF):
		match side:
			0: $spr.setup([10,11],32)
			1: $spr.setup([17,18],7)
