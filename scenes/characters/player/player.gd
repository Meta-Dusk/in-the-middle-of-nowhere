extends CharacterBody3D

const WALK_SPEED: float = 5.0
const RUN_SPEED: float = 8.0
const JUMP_VELOCITY: float = 4.5

@export var is_dead := false
var direction := Vector3.ZERO

@export var anim_tree: AnimationTree = null
const _IDLE = "parameters/conditions/idle"
const _IS_DYING = "parameters/conditions/is_dying"
const _IS_GROUNDED = "parameters/conditions/is_grounded"
const _IS_JUMPING = "parameters/conditions/is_jumping"
const _IS_WALKING = "parameters/conditions/is_walking"
const _IS_RUNNING = "parameters/conditions/is_running"

func _handle_movement() -> void:
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Determine current speed based on input
	var current_speed := RUN_SPEED if Input.is_action_pressed("sprint") else WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if not is_dead: _handle_movement()
	_update_animation_params()

func _update_animation_params() -> void:
	var is_moving := direction != Vector3.ZERO
	var is_sprinting := Input.is_action_pressed("sprint")

	# Mutually exclusive movement states
	anim_tree.set(_IDLE, not is_moving)
	anim_tree.set(_IS_WALKING, is_moving and not is_sprinting)
	anim_tree.set(_IS_RUNNING, is_moving and is_sprinting)
	
	# Jumping
	anim_tree.set(_IS_GROUNDED, is_on_floor())
	anim_tree.set(_IS_JUMPING, not is_on_floor())
	
	# Dying
	anim_tree.set(_IS_DYING, is_dead)
