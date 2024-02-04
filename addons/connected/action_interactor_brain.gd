class_name ActionInteractorBrain extends Node

signal action_emitter_connected(action_emitter: ActionEmitter)
signal action_emitter_disconnected(action_emitter: ActionEmitter)
signal action_listener_connected(action_listener: ActionListener)
signal action_listener_disconnected(action_listener: ActionListener)


var emitters: Array[ActionEmitter] = []
var listeners: Array[ActionListener] = []


func _ready():
	add_to_group("action-interactor-brain")


func connect_action_emitter(action_emitter: ActionEmitter):
	if not action_emitter.emitted_action.is_connected(on_action_emitter_action):
		emitters.append(action_emitter)
		action_emitter.emitted_action.connect(on_action_emitter_action)
		action_emitter_connected.emit(action_emitter)
			

func disconnect_action_emitter(action_emitter: ActionEmitter):
	print("ENTRO DISCONNECT")
	if action_emitter.emitted_action.is_connected(on_action_emitter_action):
		print("paso if")
		emitters.erase(action_emitter)
		action_emitter.emitted_action.disconnect(on_action_emitter_action)
		action_emitter_disconnected.emit(action_emitter)


func connect_action_listener(listener: ActionListener):
	if not listeners.has(listener):
		listeners.append(listener)
		action_listener_connected.emit(listener)


func disconnect_action_listener(listener: ActionListener):
	if listeners.has(listener):
		listeners.erase(listener)
		action_listener_disconnected.emit(listener)


func propagate_action_through_listeners(action: Action):
	var valid_listeners = listeners.duplicate()
	
	if not action.ignored_by.is_empty():
		valid_listeners = valid_listeners.filter(func(listener: ActionListener): return not listener.category in action.ignored_by)
	
	if not action.listened_by.is_empty():
		valid_listeners = valid_listeners.filter(func(listener: ActionListener): return listener.category in action.listened_by)

	valid_listeners.sort_custom(
		func(listener_a: ActionListener, listener_b: ActionListener): 
			return listener_a.priority > listener_b.priority)
		
	for listener: ActionListener in valid_listeners:
		listener.listened_action.emit(action)


func on_action_emitter_action(action: Action):
	propagate_action_through_listeners(action)
