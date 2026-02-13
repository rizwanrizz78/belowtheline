extends Node3D

func _ready():
	SaveSystem.load_game()
	# Check if we have an active contract, if not start one
	if not GameState.current_contract:
		await get_tree().create_timer(1.0).timeout
		if not is_inside_tree(): return
		var contract = DeliveryManager.generate_contract()
		DeliveryManager.start_contract(contract)
