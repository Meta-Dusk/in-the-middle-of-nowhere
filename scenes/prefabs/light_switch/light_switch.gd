extends Node

## This node should contain children of type ToggleableLight
@export var lights_node: Node = null
@export var toggle_on_start: bool = false

func _ready() -> void:
	if not toggle_on_start: return
	var anim_player: AnimationPlayer = $AnimationPlayer
	anim_player.play("open")
	anim_player.seek(anim_player.current_animation.length(), true)
	var switch: SimpleInteractable = $LightMesh/LightSwitchBody
	switch.is_open = true

func _on_light_switch_body_interacted() -> void:
	if lights_node == null: return
	for child in lights_node.get_children():
		if child is not ToggleableLight: continue
		var light = child as ToggleableLight
		light.toggle_light()
