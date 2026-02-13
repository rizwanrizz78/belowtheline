extends Control

@onready var speed_label = $Stats/Speed
@onready var heat_label = $Stats/Heat
@onready var money_label = $Stats/Money
@onready var objective_label = $Stats/Objective

func _ready():
	# Connect to GameState signals
	GameState.money_changed.connect(_on_money_changed)
	GameState.heat_changed.connect(_on_heat_changed)

	# Connect to DeliveryManager signals
	DeliveryManager.pickup_ready.connect(_on_pickup_ready)
	DeliveryManager.dropoff_ready.connect(_on_dropoff_ready)
	DeliveryManager.delivery_completed.connect(_on_delivery_completed)

	_update_money(GameState.money)
	_update_heat(GameState.heat_level)
	objective_label.text = "GOAL: Wait..."

func _process(_delta):
	# Update speed from player
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var speed = player.linear_velocity.length() * 3.6 # km/h
		speed_label.text = "SPEED: %d km/h" % speed

func _on_money_changed(new_money):
	_update_money(new_money)

func _on_heat_changed(new_heat):
	_update_heat(new_heat)

func _update_money(m):
	money_label.text = "MONEY: $%d" % m

func _update_heat(h):
	heat_label.text = "HEAT: %.1f%%" % h

func _on_pickup_ready(_pos):
	objective_label.text = "GOAL: Pickup Cargo"

func _on_dropoff_ready(_pos):
	objective_label.text = "GOAL: Deliver Cargo"

func _on_delivery_completed():
	objective_label.text = "GOAL: Contract Done!"
