class_name Action extends RefCounted

var id: String
var priority := 1
var is_listened := true
var listened_by := []
var ignored_by := []

func _init(_id: String = _generate_random_id(), _is_listened: bool = true, _priority: int = 1):
	id = _id
	is_listened = _is_listened
	priority = _priority


func before_emit() -> bool:
	return true


func after_emit()-> void:
	pass


func after_cancel() -> void:
	pass


func add_listened_by_categories(categories: Array, overwrite: bool = false) -> void:
	if overwrite:
		listened_by.clear()
		
	listened_by.append_array(categories)


func add_ignored_by_categories(categories: Array, overwrite: bool = false) -> void:
	if overwrite:
		ignored_by.clear()
		
	ignored_by.append_array(categories)
	

func _generate_random_id(length: int = 20, characters: String =  "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"):
	var random_number_generator = RandomNumberGenerator.new()
	var result = ""
	
	if not characters.is_empty() and length > 0:
		for i in range(length):
			result += characters[random_number_generator.randi() % characters.length()]

	return result
