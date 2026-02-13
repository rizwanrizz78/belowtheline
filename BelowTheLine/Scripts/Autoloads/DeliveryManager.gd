extends Node

signal pickup_ready(location)
signal dropoff_ready(location)
signal delivery_completed

var active_pickup_zone: Node3D
var active_dropoff_zone: Node3D

# Placeholder locations (will be registered by the level)
var available_points: Array[Node3D] = []

func register_point(point: Node3D):
	if not available_points.has(point):
		available_points.append(point)

func generate_contract() -> Dictionary:
	return {
		"title": "Package #" + str(randi() % 1000),
		"reward": randi_range(50, 200),
		"risk": randi_range(0, 20),
		"description": "Deliver this quickly."
	}

func start_contract(contract: Dictionary):
	GameState.accept_contract(contract)
	_spawn_pickup()

func _spawn_pickup():
	if available_points.is_empty():
		print("No delivery points registered!")
		return

	# Pick random point
	var point = available_points.pick_random()
	active_pickup_zone = point
	point.activate_as_pickup()
	pickup_ready.emit(point.global_position)
	print("Pickup spawned at ", point.name)

func on_pickup_collected():
	if active_pickup_zone:
		active_pickup_zone.deactivate()
		active_pickup_zone = null

	_spawn_dropoff()

func _spawn_dropoff():
	# Ensure distinct from previous pickup if possible
	var point = available_points.pick_random()

	active_dropoff_zone = point
	point.activate_as_dropoff()
	dropoff_ready.emit(point.global_position)
	print("Dropoff spawned at ", point.name)

func on_dropoff_delivered():
	if active_dropoff_zone:
		active_dropoff_zone.deactivate()
		active_dropoff_zone = null

	GameState.complete_contract()
	delivery_completed.emit()
	SaveSystem.save_game()
