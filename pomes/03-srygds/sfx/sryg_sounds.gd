extends Node
class_name SrygSounds

static var singleton : SrygSounds
static func GetSS() -> SrygSounds:
	return singleton

var curtone : AudioStreamPlayer
@export var atten : Curve
@export var fade_in_rate : float = 1.0
@export var fade_out_rate : float = 1.0
var domainpositions : Dictionary = Dictionary()
var base_volumes : Dictionary

func play_sound(soundname:String,override_if_playing:bool=true,opacity:float=1.0) -> void:
	var sfx : AudioStreamPlayer = $sfxes.get_node_or_null(soundname)
	if sfx == null:
		push_warning("Unknown sound "+soundname)
	elif override_if_playing or sfx.get_playback_position() > sfx.stream.get_length() * 0.5 or !sfx.playing:
		if opacity >= 1:
			sfx.volume_db = base_volumes.get(sfx, 0)
		else:
			sfx.volume_db = lerp(-40.0, base_volumes.get(sfx, 0), atten.sample_baked(opacity))
		#if opacity >= 0.5:
			#sfx.play()

func set_track(track:int) -> void:
	if track < 0 or track >= $bgms.get_child_count():
		curtone = null
	else:
		curtone = $bgms.get_child(track)

func _ready() -> void:
	singleton = self
	atten.bake()
	for tone in $bgms.get_children():
		base_volumes[tone] = tone.volume_db
	for sfx in $sfxes.get_children():
		base_volumes[sfx] = sfx.volume_db

func _physics_process(delta: float) -> void:
	for tone in $bgms.get_children():
		slide(tone, tone == curtone, delta)

func slide(tone:AudioStreamPlayer, turnon:bool, delta:float) -> void:
	var dp : float = domainpositions.get(tone,0)
	if turnon:
		if dp >= 1: return
		if dp <= 0: tone.play()
		dp = dp + delta * fade_in_rate
		if dp >= 1: dp = 1
	else:
		if dp <= 0: return
		dp = dp - delta * fade_in_rate
		if dp <= 0: dp = 0; tone.stop();
	domainpositions[tone] = dp
	if tone.playing:
		tone.volume_db = lerp(-40.0, base_volumes[tone], atten.sample_baked(dp))
