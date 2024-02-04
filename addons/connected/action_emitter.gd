class_name ActionEmitter extends Node

signal emitted_action(action: Action)
signal canceled_action(action: Action)

@onready var action_interactor_brain: ActionInteractorBrain = get_tree().get_first_node_in_group("action-interactor-brain") as ActionInteractorBrain

@export var disabled := false:
	set(value):
		if value != disabled and is_node_ready():
			if value:
				action_interactor_brain.connect_to_action_emitter(self)
			else:
				action_interactor_brain.disconnect_from_action_emitter(self)
		disabled = value


func _ready():
	add_to_group("action-emitters")
	
	emitted_action.connect(on_emitted_action)
	canceled_action.connect(on_canceled_action)
	
	if not disabled:
		action_interactor_brain.connect_to_action_emitter(self)
	
	
func _exit_tree():
	action_interactor_brain.disconnect_from_action_emitter(self)
	
	
func emit(action: Action):
	if disabled or not action.is_listened:
		return
	
	var can_be_emitted = action.before_emit()
	
	if can_be_emitted:
		emitted_action.emit(action)
	else:
		canceled_action.emit(action)
	

func enable() -> void:
	disabled = false
	
	
func disable() -> void:
	disabled = true


### SIGNAL CALLBACKS ###
func on_emitted_action(action: Action):
	action.after_emit()


func on_canceled_action(action: Action):
	action.after_cancel()
