extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var wall_ray: RayCast3D

@export var r_hand_target: Marker3D
@export var l_hand_target: Marker3D

@export var r_arm_ik: CCDIK3D
@export var l_arm_ik: CCDIK3D

@export var r_hand_ik: CopyTransformModifier3D
@export var l_hand_ik: CopyTransformModifier3D

@export var wall_offset: float = 0.15
@export var side_offset: float = 0.3

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _ready() -> void:
	var r_arm_path = r_hand_target.get_path()
	var l_arm_path = l_hand_target.get_path()
	
	r_arm_ik.set_target_node(0, r_arm_path)
	l_arm_ik.set_target_node(0, l_arm_path)
	
	r_hand_ik.set_reference_node(0, r_arm_path)
	l_hand_ik.set_reference_node(0, l_arm_path)

func _process(delta: float) -> void:
	if wall_ray.is_colliding():
		var hit_point: Vector3 = wall_ray.get_collision_point()
		var hit_normal: Vector3 = wall_ray.get_collision_normal()
		var wall_right: Vector3 = Vector3.UP.cross(hit_normal).normalized()
		
		r_hand_target.global_position = hit_point + (hit_normal * wall_offset) + (wall_right * side_offset)
		l_hand_target.global_position = hit_point + (hit_normal * wall_offset) + (wall_right * -side_offset)
		
		r_arm_ik.influence = lerp(r_arm_ik.influence, 1.0, 10.0 * delta)
		l_arm_ik.influence = lerp(l_arm_ik.influence, 1.0, 10.0 * delta)
		
		r_hand_ik.influence = lerp(r_hand_ik.influence, 1.0, 10.0 * delta)
		l_hand_ik.influence = lerp(l_hand_ik.influence, 1.0, 10.0 * delta)
	else:
		r_arm_ik.influence = lerp(r_arm_ik.influence, 0.0, 10.0 * delta)
		l_arm_ik.influence = lerp(l_arm_ik.influence, 0.0, 10.0 * delta)
		
		r_hand_ik.influence = lerp(r_hand_ik.influence, 0.0, 10.0 * delta)
		l_hand_ik.influence = lerp(l_hand_ik.influence, 0.0, 10.0 * delta)
