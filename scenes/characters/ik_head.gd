extends Node3D

@export var head_target: NodePath

func _attach_head_target() -> void:
	if head_target.is_empty():
		push_warning("head_target is empty! Defaulting to marker.")
		return
	
	var target_node = get_node_or_null(head_target)
	if target_node:
		$Skeleton3D/Head.target_node = $Skeleton3D/Head.get_path_to(target_node)
		print_debug("Successfully bound head_target.")
	else:
		push_warning("Could not find target node from path: ", head_target)

func _ready() -> void:
	_attach_head_target()
