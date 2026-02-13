extends Node

var move_vector: Vector2 = Vector2.ZERO
var accelerate: bool = false
var brake: bool = false
var interact: bool = false

func get_move_vector() -> Vector2:
	return move_vector

func is_accelerating() -> bool:
	return accelerate

func is_braking() -> bool:
	return brake

func is_interacting() -> bool:
	return interact
