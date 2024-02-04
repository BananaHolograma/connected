class_name ActionListener extends Node

signal listened_action(action: Action)

@export var category: String
@export_range(1, 1000, 1) var priority := 1
@export var disabled := false:
	set(value):
		if value != disabled and is_node_ready():
			if value:
				action_interactor_brain.disconnect_action_listener(self)
			else:
				action_interactor_brain.connect_action_listener(self)
		disabled = value

@onready var action_interactor_brain: ActionInteractorBrain = get_tree().get_first_node_in_group("action-interactor-brain") as ActionInteractorBrain

func _ready():
	add_to_group("action-listeners")
	if not disabled:
		action_interactor_brain.connect_action_listener(self)


func _exit_tree():
	action_interactor_brain.disconnect_action_listener(self)
	
	
func enable() -> void:
	disabled = false
	
	
func disable() -> void:
	disabled = true
