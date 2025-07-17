extends Node2D

var ghost_node: Area2D = null
var is_placing := false
@onready var scene_to_instance = preload("res://Factory/machines/drill.tscn")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Defense/defense.tscn")

func drill_pressed():
	ghost_node = scene_to_instance.instantiate()
	ghost_node.monitoring = true
	ghost_node.get_node("AnimatedSprite2D").z_index = 10
	add_child(ghost_node)
	is_placing = true

func _process(delta):
	if not is_placing or ghost_node == null:
		return

	var grid_size = 32
	var mouse_pos = get_global_mouse_position()

	var snapped_pos = Vector2(
		round(mouse_pos.x / grid_size) * grid_size,
		round(mouse_pos.y / grid_size) * grid_size
	)

	ghost_node.global_position = snapped_pos

	if ghost_node.get_overlapping_areas().is_empty():
		ghost_node.modulate = Color(1, 1, 1, 0.8)
	else:
		ghost_node.modulate = Color(1, 0, 0, 0.8)

func _unhandled_input(event):
	if is_placing and event is InputEventMouseButton and event.pressed:
		if ghost_node and ghost_node.get_overlapping_areas().is_empty():
			is_placing = false
			ghost_node.modulate = Color(1, 1, 1)
			ghost_node = null
