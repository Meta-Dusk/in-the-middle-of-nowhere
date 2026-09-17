class_name Openable
extends Interactable

var is_open: bool = false
@export var anim_player: AnimationPlayer = null
@export var anim_tweaker: AnimationTweaker = null	

const available_anims = ["open", "close", "open_alt", "close_alt"]

func _ready() -> void:
	if anim_player == null:
		push_warning("Mising AnimationPlayer!")

func interact() -> void:
	var current_anim: String = anim_player.current_animation
	if current_anim in available_anims: return
	
	is_open = !is_open
	var animation: String = "open" if is_open else "close"
	if anim_tweaker.alt_animations:
		animation = "open_alt" if is_open else "close_alt"
	anim_player.play(animation)
