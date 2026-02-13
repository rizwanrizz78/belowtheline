extends Node

signal money_changed(new_amount)
signal heat_changed(new_heat)
signal contract_accepted(contract_data)
signal contract_completed(contract_data)
signal contract_failed(contract_data)

var money: int = 0:
	set(value):
		money = value
		money_changed.emit(money)

var heat_level: float = 0.0:
	set(value):
		heat_level = clamp(value, 0.0, 100.0)
		heat_changed.emit(heat_level)

var current_contract = null # Dictionary or null
var inventory: Array = []

func _ready():
	# Initialize with defaults if needed
	pass

func add_money(amount: int):
	money += amount

func add_heat(amount: float):
	heat_level += amount

func reduce_heat(amount: float):
	heat_level -= amount

func accept_contract(contract: Dictionary):
	current_contract = contract
	contract_accepted.emit(contract)
	print("Contract Accepted: ", contract)

func complete_contract():
	if current_contract:
		add_money(current_contract.get("reward", 0))
		contract_completed.emit(current_contract)
		current_contract = null
		print("Contract Completed")

func fail_contract():
	if current_contract:
		contract_failed.emit(current_contract)
		current_contract = null
		print("Contract Failed")

func get_save_data() -> Dictionary:
	return {
		"money": money,
		"heat_level": heat_level,
		"current_contract": current_contract,
		"inventory": inventory
	}

func load_save_data(data: Dictionary):
	money = data.get("money", 0)
	heat_level = data.get("heat_level", 0.0)
	current_contract = data.get("current_contract", null)
	inventory = data.get("inventory", [])
