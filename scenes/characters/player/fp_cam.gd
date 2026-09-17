extends Node3D

@export var sensitivity: float = 0.2
@export var flashlight: SpotLight3D = null

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("flashlight"):
		if flashlight == null: return
		flashlight.visible = !flashlight.visible

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var parent: Node3D = get_parent()
		parent.rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(90))
