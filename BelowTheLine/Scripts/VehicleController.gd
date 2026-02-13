extends VehicleBody3D

@export var max_engine_force = 300.0
@export var max_brake_force = 10.0
@export var max_steering = 0.6 # radians
@export var steering_speed = 5.0

func _ready():
	add_to_group("player")
	contact_monitor = true
	max_contacts_reported = 2
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Simple collision impact based on speed
	var impact = linear_velocity.length()
	HeatManager.on_collision(impact)

func _physics_process(delta):
	# Check speeding
	var speed_kph = linear_velocity.length() * 3.6
	if speed_kph > 100.0:
		HeatManager.on_speeding(speed_kph - 100.0)

	# Steering
	var steer_target = MobileInput.get_move_vector().x * -max_steering # Invert if needed
	steering = move_toward(steering, steer_target, delta * steering_speed)

	# Acceleration
	if MobileInput.is_accelerating():
		engine_force = max_engine_force
	elif MobileInput.is_braking():
		# Check if we are moving forward
		# Transform basis Z is backward in Godot
		# -transform.basis.z is forward
		var forward_vel = linear_velocity.dot(-transform.basis.z)

		if forward_vel > 1.0:
			# Braking
			engine_force = 0.0
			brake = max_brake_force
		else:
			# Reversing
			engine_force = -max_engine_force / 2.0
			brake = 0.0
	else:
		engine_force = 0.0
		brake = 0.0 # Coasting

	# Simple "flip car" logic if stuck upside down
	if Input.is_action_just_pressed("ui_accept") or (MobileInput.is_interacting() and abs(rotation.z) > 1.5):
		rotation.z = 0
		rotation.x = 0
		position.y += 2.0
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
