extends RayCast3D

func _physics_process(_delta: float) -> void:
	if not is_colliding(): return
	var hit: Object = get_collider()
	if hit is Interactable and Input.is_action_just_pressed("interact"):
		var object: Interactable = hit
		object.interact()
