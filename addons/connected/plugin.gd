@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("ActionEmitter", "Node", preload("res://addons/connected/action_emitter.gd"), preload("res://addons/connected/icons/action-emitter.svg"))
	add_custom_type("ActionListener", "Node", preload("res://addons/connected/action_listener.gd"), preload("res://addons/connected/icons/action-listener.svg"))
	add_autoload_singleton("ActionInteractor", "res://addons/connected/action_interactor_brain.gd")


func _exit_tree():
	remove_custom_type("ActionEmitter")
	remove_custom_type("ActionListener")
	remove_autoload_singleton("ActionInteractor")
