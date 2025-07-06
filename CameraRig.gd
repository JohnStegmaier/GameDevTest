extends Node3D

@export var target: Node3D
@export var follow_speed: float = 5.0
@export var distance: float = 10.0
@export var height: float = 5.0
@export var rotation_speed: float = 5.0

var current_rotation_y: float = 0.0
var last_target_position: Vector3

func _ready():
	if target:
		last_target_position = target.global_transform.origin

func _process(delta):
	if not target:
		return

	var current_target_position = target.global_transform.origin
	var movement = current_target_position - last_target_position
	movement.y = 0  # Ignore vertical movement

	# Only update rotation if the ball is moving
	if movement.length() > 0.05:
		var movement_direction = movement.normalized()
		var target_rotation_y = atan2(movement_direction.x, movement_direction.z)
		current_rotation_y = lerp_angle(current_rotation_y, target_rotation_y, rotation_speed * delta)

	# Calculate the camera's position behind the target
	var offset = Vector3(
		sin(current_rotation_y) * distance,
		0,
		cos(current_rotation_y) * distance
	)

	var desired_position = current_target_position - offset
	desired_position.y += height

	# Smooth camera movement
	global_transform.origin = global_transform.origin.lerp(desired_position, follow_speed * delta)

	# Make the camera look at the target
	look_at(current_target_position, Vector3.UP)

	# Store position for next frame
	last_target_position = current_target_position
