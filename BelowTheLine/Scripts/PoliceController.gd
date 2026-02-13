extends VehicleBody3D

@export var max_engine_force = 450.0
@export var max_steering = 0.5
@export var steering_speed = 3.0

var target: Node3D

func _ready():
	add_to_group("police")
	# Wait for player to exist
	await get_tree().process_frame
	target = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if not target:
		target = get_tree().get_first_node_in_group("player")
		return

	# Simple Chase AI
	var my_pos = global_position
	var target_pos = target.global_position
	var direction = (target_pos - my_pos).normalized()

	# Get our forward vector (-Z)
	var forward = -global_transform.basis.z

	# Calculate angle to target relative to our forward vector
	var angle = forward.signed_angle_to(direction, Vector3.UP)

	# Steer towards target
	steering = move_toward(steering, clamp(angle, -max_steering, max_steering), delta * steering_speed)

	# Throttle logic
	if abs(angle) < 0.5:
		engine_force = max_engine_force
	elif abs(angle) > 1.0:
		engine_force = max_engine_force * 0.3 # Slow down on sharp turns
	else:
		engine_force = max_engine_force * 0.8

	# Unflip if stuck
	if abs(rotation.z) > 1.5 or abs(rotation.x) > 1.5:
		rotation.z = 0
		rotation.x = 0
		position.y += 2
		linear_velocity = Vector3.ZERO
