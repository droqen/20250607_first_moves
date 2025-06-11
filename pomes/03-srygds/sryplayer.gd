extends NavdiSolePlayer

@onready var spr : SheetSprite = $spr
@onready var mover = $mover
@onready var solidcast = $mover/cast
@onready var clingmover = $cling_mover
@onready var clingcast = $cling_mover/cast

var voiceless : bool : 
	get() : return bufs.has(CRAWLBUF)

var _front_thoughts : Array[String]
var front_thoughts : Array[String] :
	get( ) : return _front_thoughts
	set(v) :
		_front_thoughts = v
		$playerspeak.messages = _front_thoughts

var vx : float;
var vy : float;
var onwall : int = 0;
var lastonwall : int = 0;
enum { WALLHOPPEDBUF, NOLEFTBUF, WALLCLINGBUF, CRAWLBUF, }
var bufs : Bufs = Bufs.Make(self).setup_bufons([
	WALLHOPPEDBUF, 25, NOLEFTBUF, 3, WALLCLINGBUF, 6, CRAWLBUF, 3, 
])

var fading_in : bool = true

func _ready() -> void:
	super._ready()
	modulate.a = 0

func _physics_process(delta: float) -> void:
	
	if voiceless:
		$playerspeak.shhh()
	
	if fading_in:
		if modulate.a < 1:
			modulate.a += delta
		else:
			modulate.a = 1
			fading_in = false
	var dpad = Pin.get_dpad()
	if dpad.x < 0 and bufs.has(NOLEFTBUF): dpad.x = 0
	var onfloor : bool = vy >= 0 and mover.cast_fraction(self,solidcast,VERTICAL,1)<1
	if onfloor: bufs.clr(WALLHOPPEDBUF)
		
	var crawl : bool = onfloor and dpad.y > 0
	if crawl: bufs.on(CRAWLBUF)
	if dpad.x != 0:
		if (dpad.x * vx >= 0) and !crawl:
			if clingmover.cast_fraction(self,clingcast,HORIZONTAL,dpad.x)<1:
				onwall = dpad.x
				if onwall:
					lastonwall = onwall
		if (dpad.x * onwall < 0):
			onwall = 0
	if onwall: bufs.on(WALLCLINGBUF)
	if onwall and clingmover.cast_fraction(self,clingcast,HORIZONTAL,onwall)>0.9:
		onwall = 0
		if vy < 0:
			vy = -1.1
			bufs.on(WALLHOPPEDBUF)
	if onwall * dpad.x > 0 and dpad.y == 0:
		dpad.y = -1
	if crawl:
		vx = move_toward(vx, dpad.x * 0.4, 0.1)
	elif bufs.has(WALLHOPPEDBUF) and dpad.x == 0:
		vx = move_toward(vx, lastonwall * 0.5, 0.1)
	else:
		vx = move_toward(vx, dpad.x, 0.1)
	if onwall:
		vy = move_toward(vy, dpad.y * 0.5, 0.1)
	else:
		vy += 0.1
		if vy > 0: vy *= 0.97
	if Pin.get_jump_hit():
		if bufs.try_eat([WALLCLINGBUF]):
			if onwall: vx = -onwall*0.5
			onwall = 0
			vy = -1.4
		if onfloor:
			onfloor = false; vy = -1.4
	if vx and!mover.try_slip_move(self,solidcast,HORIZONTAL,vx): vx=0
	if vy and!mover.try_slip_move(self,solidcast,VERTICAL,vy): vy=0
	if onwall:
		spr.rotation = 0
		spr.flip_h = onwall < 0
		if dpad.y : spr.setup([25,24],14)
		else: spr.setup([24])
	elif crawl:
		spr.rotation = PI * 0.5
		if spr.flip_h: spr.rotation *= -1
		if dpad.x : spr.setup([25,24],22)
		else: spr.setup([24])
	else:
		spr.rotation = 0
		if dpad.x : spr.flip_h = dpad.x < 0
		if dpad.x : spr.setup([35,34],9)
		else: spr.setup([34])
