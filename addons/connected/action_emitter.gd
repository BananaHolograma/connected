class_name ActionEmitter extends Node

signal emitted_action(action: Action)
signal canceled_action(action: Action)

@export var disabled := false


func _enter_tree():
	add_to_group("action-emitters")
	name = "ActionEmitter"
	
func _ready():
	emitted_action.connect(on_emitted_action)
	canceled_action.connect(on_canceled_action)
	

func send(action: Action):
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
