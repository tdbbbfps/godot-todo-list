extends Control
class_name App
@export var todo_item_container : VBoxContainer
@export var todo_edit : TodoEdit

const TODO_ITEM = preload("res://app/system/todo_item/todo_item.tscn")
var todo_list : Array = []

func _ready() -> void:
	todo_edit._on_todo_added.connect(add_todo)
	
func add_todo(todo_info : Dictionary):
	var todo_item = TODO_ITEM.instantiate()
	todo_item.set_todo(todo_info)
	todo_item_container.add_child(todo_item)
	todo_list.append(todo_info)
	todo_item._on_todo_removed.connect(sort_todo_list)
	
func sort_todo_list():
	pass
