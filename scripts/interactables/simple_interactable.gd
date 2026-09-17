class_name SimpleInteractable
extends Interactable

signal interacted
var is_open: bool = false
@export var anim_player: AnimationPlayer = null

const available_anims = ["open", "close"]

func _check_anim_player() -> bool:
	if anim_player == null:
		push_error("Mising AnimationPlayer!")
		return false
	return true

func _ready() -> void:
	_check_anim_player()

func interact() -> void:
	if not _check_anim_player(): return
	var current_anim: String = anim_player.current_animation
	if current_anim in available_anims: return
	
	is_open = not is_open
	var animation: String = "open" if is_open else "close"
	anim_player.play(animation)
	interacted.emit()
