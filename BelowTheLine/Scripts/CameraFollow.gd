extends Camera3D

@export var target_path: NodePath
@export var offset: Vector3 = Vector3(0, 5, 8)
@export var smooth_speed: float = 5.0

var target: Node3D

func _ready():
	if target_path:
		target = get_node(target_path)
	else:
		# Try to find parent vehicle if not set
		var parent = get_parent()
		if parent is VehicleBody3D:
			target = parent
			# Detach to avoid rotation
			top_level = true

func _physics_process(delta):
	if target:
		# Simple follow logic
		# Maintain offset relative to world or target?
		# Arcade style usually follows behind the car.

		# Calculate target position behind the car
		var target_basis = target.global_transform.basis
		var target_pos = target.global_position

		# Transform offset to be relative to car rotation (Yaw only)
		# We want the camera to stay behind, but not roll/pitch violently.

		# Get car's forward vector (negative Z)
		var forward = -target_basis.z
		forward.y = 0 # Ignore pitch
		forward = forward.normalized()

		# Actually, let's just use `look_at` from a position.

		# Desired position: behind and above
		# Behind = +Z relative to car (since forward is -Z)
		# Up = +Y

		# We construct a position based on target's Yaw.
		var rot_y = target.global_rotation.y
		var offset_rotated = offset.rotated(Vector3.UP, rot_y)

		var desired_pos = target_pos + offset_rotated

		global_position = global_position.lerp(desired_pos, delta * smooth_speed)
		look_at(target_pos + Vector3(0, 1, 0), Vector3.UP)
