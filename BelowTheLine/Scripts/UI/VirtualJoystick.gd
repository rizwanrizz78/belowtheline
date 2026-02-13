extends Control

@export var max_distance: float = 75.0

@onready var _base = $Base
@onready var _handle = $Base/Handle

var _touch_index: int = -1

func _ready():
	# Ensure handle is centered
	await get_tree().process_frame
	_reset_handle()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if _touch_index == -1:
				# Check if touch is within the control rect
				if get_global_rect().has_point(event.position):
					_touch_index = event.index
					_update_handle(event.position)
		elif event.index == _touch_index:
			_touch_index = -1
			_reset_handle()

	elif event is InputEventScreenDrag:
		if event.index == _touch_index:
			_update_handle(event.position)

func _update_handle(pos: Vector2) -> void:
	var base_center = _base.global_position + _base.size / 2
	var vector = pos - base_center

	if vector.length() > max_distance:
		vector = vector.normalized() * max_distance

	_handle.global_position = base_center + vector - _handle.size / 2

	# Update global input
	# X is steering (left/right), Y is usually forward/back but here joystick is steering only?
	# "Virtual joystick -> movement / steering"
	# Usually left stick is steering (X) and maybe camera pitch (Y)? Or throttle?
	# "Left side: Virtual joystick -> movement / steering"
	# "Right side: Accelerate button, Brake / reverse button"
	# So Joystick X is steering. Joystick Y is... maybe nothing? Or camera?
	# I'll map X to steering. Y is ignored for now.
	MobileInput.move_vector = vector / max_distance

func _reset_handle() -> void:
	var base_center = _base.global_position + _base.size / 2
	_handle.global_position = base_center - _handle.size / 2
	MobileInput.move_vector = Vector2.ZERO
