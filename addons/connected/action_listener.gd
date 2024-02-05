class_name ActionListener extends Node

signal listened_action(action: Action)

@export var category: String
@export_range(1, 1000, 1) var priority := 1
@export var disabled := false


func _enter_tree():
	add_to_group("action-listeners")
	name = "ActionListener"
	

func enable() -> void:
	disabled = false
	
	
func disable() -> void:
	disabled = true
