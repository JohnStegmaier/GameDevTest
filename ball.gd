extends RigidBody3D

@export var speed = 10
@export var camera: Node3D  # drag in the CameraRig or Camera3D node from the editor

func _physics_process(delta):
	if camera == null:
		return

	var input_vector = Vector3.ZERO

	if Input.is_action_pressed("ui_up"):
		input_vector.z += 1
	if Input.is_action_pressed("ui_down"):
		input_vector.z -= 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1

	input_vector = input_vector.normalized()

	if input_vector != Vector3.ZERO:
		# Get the camera's basis vectors (local X and Z axes)
		var cam_basis = camera.global_transform.basis
		var forward = -cam_basis.z
		var right = cam_basis.x

		# Flatten them to avoid vertical movement
		forward.y = 0
		right.y = 0
		forward = forward.normalized()
		right = right.normalized()

		# Convert input into world direction based on camera
		var move_direction = (forward * input_vector.z) + (right * input_vector.x)

		apply_central_force(move_direction * speed)
