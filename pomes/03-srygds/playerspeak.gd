extends Label
@export var messages : Array[String]

@export var front_thoughts : bool = false
@export var stranger_thoughts : bool = false

func shhh() -> void:
	if !curbksp:
		curbksp = true
		if visible_characters > 0 and curlinger > 0: curlinger = 0

var curid : int = -1
var cursubtype : int = 0
var curmsglen : int = 0
var curlinger : int = 0
var curbksp : bool = false

var bipname : String
var byename : String

func _ready() -> void:
	pickmessage()
	bipname = "bip_inner"
	if front_thoughts: bipname = "bip_outer"
	if stranger_thoughts: bipname = "bip_stranger"
	byename = bipname.replace("bip","bye")
func pickmessage() -> void:
	if messages:
		var messagect : int = len(messages)
		if curid < 0:
			curid = randi() % messagect
			text = messages[curid]
			visible_ratio = randf()
			curbksp = randf() < 0.5
		else:
			curid = (curid + 1 + randi()%(messagect-1)) % messagect
			text = messages[curid]
			visible_characters = 0
			curbksp = false
			cursubtype = -(randi()%100)
		if not curbksp:
			curlinger = 100 + 2*curmsglen + randi()%30
		curmsglen = len(messages[curid])
	else:
		text = ''
func _physics_process(_delta: float) -> void:
	cursubtype += 1
	if cursubtype >= 4:
		var opacity : float = 1.0
		if modulate.a < 1.0: opacity *= modulate.a
		if get_parent().modulate.a < 1.0: opacity *= get_parent().modulate.a
		if not curbksp:
			cursubtype = 0
			visible_characters += 1
			SrygSounds.GetSS().play_sound(bipname,true,opacity)
			if visible_ratio >= 1.0:
				curbksp = true
		elif curlinger > 0:
			curlinger -= 1
		else:
			cursubtype = 2
			if visible_characters > 0:
				visible_characters -= 1
				SrygSounds.GetSS().play_sound(byename,false,opacity)
			if visible_characters <= 0:
				pickmessage()
