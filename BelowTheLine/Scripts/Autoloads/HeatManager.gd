extends Node

const HEAT_DECAY_RATE = 2.0
const POLICE_SCENE = preload("res://Scenes/PoliceVehicle.tscn")

var police_count = 0
var max_police = 3
var spawn_timer = 0.0

func _process(delta):
	# Decay heat over time if not increasing
	if GameState.heat_level > 0:
		GameState.reduce_heat(HEAT_DECAY_RATE * delta)

	# Spawn logic
	if GameState.heat_level > 25.0:
		spawn_timer += delta
		if spawn_timer > 5.0: # Check every 5 seconds
			spawn_timer = 0
			if police_count < (GameState.heat_level / 20.0): # More heat, more police
				_spawn_police()

func _spawn_police():
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return

	# Spawn behind player
	var spawn_pos = player.global_position + (player.global_transform.basis.z * 30.0)
	spawn_pos.y = 2.0

	var police = POLICE_SCENE.instantiate()
	# Add to main scene (MainGame node usually)
	get_tree().current_scene.add_child(police)
	police.global_position = spawn_pos
	police.look_at(player.global_position, Vector3.UP)

	police_count += 1
	# Monitor police destruction to decrease count?
	# For prototype, just let them accumulate or despawn far away.

func on_speeding(speed_over_limit):
	GameState.add_heat(speed_over_limit * 0.05) # Reduced multiplier

func on_collision(force):
	if force > 10.0:
		GameState.add_heat(force * 0.2)

func on_illegal_cargo_detected():
	GameState.add_heat(20.0)
