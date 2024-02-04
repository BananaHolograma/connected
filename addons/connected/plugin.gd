@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("ActionEmitter", "Node", preload("res://addons/connected/action_emitter.gd"), Texture2D.new())
	add_custom_type("ActionListener", "Node", preload("res://addons/connected/action_listener.gd"), Texture2D.new())
	add_autoload_singleton("ActionInteractor", "res://addons/connected/action_interactor_brain.gd")


func _exit_tree():
	remove_custom_type("ActionEmitter")
	remove_custom_type("ActionListener")
	remove_autoload_singleton("ActionInteractor")
