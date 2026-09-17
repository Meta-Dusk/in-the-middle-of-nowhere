extends Node

## This node should contain children of type ToggleableLight
@export var lights_node: Node = null

func _on_light_switch_body_interacted() -> void:
	if lights_node == null: return
	for child in lights_node.get_children():
		if child is not ToggleableLight: continue
		var light = child as ToggleableLight
		light.toggle_light()
