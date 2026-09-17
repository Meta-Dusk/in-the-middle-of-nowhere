class_name ToggleableLight
extends Node3D

@export var is_on: bool = true
@export var off_material: Material = null
@export var light: Light3D = null

func _ready() -> void:
	_toggle_material()
	_toggle_light()

func _toggle_material() -> void:
	if off_material == null:
		push_warning("off_material is null!")
		return
	if light == null:
		push_warning("light is null!")
		return
		
	var mat = off_material if not is_on else null
	$LampMesh.set_surface_override_material(0, mat)

func _toggle_light() -> void:
	if light == null: return
	light.visible = is_on

func toggle_light() -> void:
	is_on = not is_on
	_toggle_material()
	_toggle_light()
