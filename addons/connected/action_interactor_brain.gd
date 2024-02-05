extends Node

signal action_emitter_connected(action_emitter: ActionEmitter)
signal action_emitter_disconnected(action_emitter: ActionEmitter)
signal action_listener_connected(action_listener: ActionListener)
signal action_listener_disconnected(action_listener: ActionListener)

@onready var emitters: Array[ActionEmitter] = get_current_action_emitters()
@onready var listeners: Array[ActionListener] = get_current_action_listeners()


func _ready():
	add_to_group("action-interactor-brain")
	
	var scene_tree: SceneTree = get_tree()
	scene_tree.node_added.connect(on_node_added_to_scene_tree)
	scene_tree.node_removed.connect(on_node_removed_from_scene_tree)
	
	for emitter in emitters:
		connect_action_emitter(emitter)
		
	for listener in listeners:
		connect_action_listener(listener)
	
	
func connect_action_emitter(action_emitter: ActionEmitter):
	if not action_emitter.emitted_action.is_connected(on_action_emitter_action):
		emitters.append(action_emitter)
		action_emitter.emitted_action.connect(on_action_emitter_action)
		action_emitter_connected.emit(action_emitter)
			

func disconnect_action_emitter(action_emitter: ActionEmitter):
	if action_emitter.emitted_action.is_connected(on_action_emitter_action):
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
	var valid_listeners = listeners.duplicate().filter(func(listener: ActionListener): return not listener.disabled)
	
	if not action.ignored_by.is_empty():
		valid_listeners = valid_listeners.filter(func(listener: ActionListener): return not listener.category in action.ignored_by)
	
	if not action.listened_by.is_empty():
		valid_listeners = valid_listeners.filter(func(listener: ActionListener): return listener.category in action.listened_by)

	valid_listeners.sort_custom(
		func(listener_a: ActionListener, listener_b: ActionListener): 
			return listener_a.priority > listener_b.priority)
		
	for listener: ActionListener in valid_listeners:
		listener.listened_action.emit(action)


func get_current_action_emitters() -> Array[ActionEmitter]:
	var emitters: Array[ActionEmitter] = []
	var nodes = get_tree().get_nodes_in_group("action-emitters").filter(func(node): return node is ActionEmitter)
	
	## We need to do this manual asignation to make the typed array works for the compiler
	for node: ActionEmitter in nodes:
		emitters.append(node)
		
	return emitters


func get_current_action_listeners() -> Array[ActionListener]:
	var listeners: Array[ActionListener] = []
	var nodes = get_tree().get_nodes_in_group("action-listeners").filter(func(node): return node is ActionListener)
	
	## We need to do this manual asignation to make the typed array works for the compiler
	for node: ActionListener in nodes:
		listeners.append(node)
		
	return listeners


### SIGNAL CALLBACKS ###
func on_node_added_to_scene_tree(node):
	if node is ActionEmitter:
		connect_action_emitter(node)
	
	if node is ActionListener:
		connect_action_listener(node)


func on_node_removed_from_scene_tree(node):
	if node is ActionEmitter:
		disconnect_action_emitter(node)
	
	if node is ActionListener:
		disconnect_action_listener(node)
	

func on_action_emitter_action(action: Action):
	propagate_action_through_listeners(action)
