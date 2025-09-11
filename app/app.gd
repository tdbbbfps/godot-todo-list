extends Control
class_name App
@export var todo_item_container : VBoxContainer
@export var todo_edit : TodoEdit

const TODO_ITEM = preload("res://app/system/todo_item/todo_item.tscn")
var todo_list : Dictionary = {} # Todo ID : Todo Data
var todo_items : Dictionary = {} # Todo ID : Todo Item(UI)
var next_id : int = 1
@export var clean_btn : Button

func _ready() -> void:
	todo_edit._on_todo_added.connect(add_todo)
	clean_btn.pressed.connect(clear_completed_todos)

# Test
func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_left")):
		prints(get_completed_todo())
	if (event.is_action_pressed("ui_right")):
		prints(get_pending_todo())

# Add todo and instantiate ui item.
func add_todo(todo : Dictionary):
	todo["id"] = next_id
	todo_list[todo["id"]] = todo
	# Create todo item ui
	var todo_item = TODO_ITEM.instantiate()
	todo_item.set_todo(todo)
	todo_item_container.add_child(todo_item)
	# Connect signals
	todo_item._on_todo_removed.connect(_on_todo_removed)
	todo_item._on_todo_completed.connect(_on_todo_completed)
	todo_item._on_todo_canceled.connect(_on_todo_canceled)
	# Bind id and item.
	todo_items[todo["id"]] = todo_item
	
	next_id += 1
	prints("Added new todo:", todo)

# Remove todo.
func _on_todo_removed(todo_id : int):
	if (not todo_list.has(todo_id)):
		printerr("There's no id%d in todo list." %todo_id)
		return
	todo_list.erase(todo_id)

	var ui_item = todo_items[todo_id]
	if (ui_item):
		ui_item.queue_free()
		todo_items.erase(todo_id)
	refresh_todo_id()

# Complete todo.
func _on_todo_completed(todo_id : int):
	if (not todo_list.has(todo_id)):
		printerr("There's no id%d in todo list." %todo_id)
		return
	var todo = todo_list[todo_id]
	if (not todo):
		printerr("Todo doesn't exist!")
		return
	if (not todo.get("completed", false)):
		todo["completed"] = true
# Cancel completed todo.
func _on_todo_canceled(todo_id : int):
	if (not todo_list.has(todo_id)):
		printerr("There's no id%d in todo list." %todo_id)
		return
	var todo = todo_list[todo_id]
	if (not todo):
		printerr("Todo doesn't exist!")
		return
	if (todo.get("completed", false)):
		todo["completed"] = false

# Return a list of completed todos' id.
func get_completed_todo():
	var completed : Array = []
	for id in todo_list.keys():
		var todo : Dictionary = todo_list[id]
		if (todo.get("completed", false)): # If ture, append
			completed.append(id)
	return completed
	
# Return a list of pending todos' id.
func get_pending_todo():
	var pending : Array = []
	for id in todo_list.keys():
		var todo : Dictionary = todo_list[id]
		if (not todo.get("completed", false)): # If ture, append
			pending.append(id)
	return pending

# Remove all completed todos.
func clear_completed_todos():
	if (not todo_list.size() > 0):
		return
	for id in todo_list.keys():
		var todo : Dictionary = todo_list[id]
		if (todo.get("completed", false)):
			todo_list.erase(id)
			todo_items[id].queue_free()
			todo_items.erase(id)
	refresh_todo_id()

func refresh_todo_id():
	var new_id : int = 1
	var new_todo_list : Dictionary = {}
	# Clear todo items ui
	for item in todo_items.keys():
		todo_items[item].queue_free()
	todo_items.clear()
	# Sort todo_list here
	
	# Rearrange id and recreate item ui
	for id in todo_list.keys():
		var todo : Dictionary = todo_list[id]
		todo["id"] = new_id
		new_todo_list[new_id] = todo
		# Create todo item ui
		var todo_item = TODO_ITEM.instantiate()
		todo_item.set_todo(todo)
		todo_item_container.add_child(todo_item)
		# Connect signals
		todo_item._on_todo_removed.connect(_on_todo_removed)
		todo_item._on_todo_completed.connect(_on_todo_completed)
		todo_item._on_todo_canceled.connect(_on_todo_canceled)
		# Bind id and item.
		todo_items[todo["id"]] = todo_item
		new_id += 1
	todo_list.clear()
	todo_list = new_todo_list
	next_id = new_todo_list.size() + 1

func sort_by_duetime():
	pass
