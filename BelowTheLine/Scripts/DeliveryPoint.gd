extends Area3D

var is_active_pickup = false
var is_active_dropoff = false

@onready var marker = $Marker

func _ready():
	# Wait for singleton to be ready
	await get_tree().process_frame
	if not is_inside_tree(): return
	DeliveryManager.register_point(self)
	deactivate()

func activate_as_pickup():
	is_active_pickup = true
	is_active_dropoff = false
	marker.visible = true
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color.GREEN
	mat.emission_enabled = true
	mat.emission = Color.GREEN
	marker.material_override = mat
	monitoring = true

func activate_as_dropoff():
	is_active_pickup = false
	is_active_dropoff = true
	marker.visible = true
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color.RED
	mat.emission_enabled = true
	mat.emission = Color.RED
	marker.material_override = mat
	monitoring = true

func deactivate():
	is_active_pickup = false
	is_active_dropoff = false
	marker.visible = false
	monitoring = false

func _on_body_entered(body):
	if body is VehicleBody3D:
		if is_active_pickup:
			DeliveryManager.on_pickup_collected()
		elif is_active_dropoff:
			DeliveryManager.on_dropoff_delivered()
