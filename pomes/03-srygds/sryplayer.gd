extends NavdiSolePlayer

@onready var spr : SheetSprite = $spr
@onready var mover = $mover
@onready var solidcast = $mover/cast

var vx : float;
var vy : float;

func _ready() -> void:
	super._ready()

func _physics_process(_delta: float) -> void:
	var dpad = Pin.get_dpad()
	var onfloor : bool = vy >= 0 and mover.cast_fraction(self,solidcast,VERTICAL,1)<1
	vx = move_toward(vx, dpad.x, 0.1)
	vy = move_toward(vy, 2.0, 0.04)
	if onfloor and Pin.get_jump_hit():
		onfloor = false; vy = -1.3
	if vx and!mover.try_slip_move(self,solidcast,HORIZONTAL,vx): vx=0
	if vy and!mover.try_slip_move(self,solidcast,VERTICAL,vy): vy=0
	if dpad.x : spr.flip_h = dpad.x < 0
	if dpad.x : spr.setup([35,34],9)
	else: spr.setup([34])
