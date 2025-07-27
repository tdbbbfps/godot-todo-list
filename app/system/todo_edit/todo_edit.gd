extends HBoxContainer
class_name TodoEdit

@export var app : App
@export var todo_input : LineEdit
@export var add_btn : Button
@export var date_btn : Button
signal _on_todo_added
var todo_date : Dictionary = {"year" : 2025, "month" : 7, "day": 27}

func _ready() -> void:
	Calendar._on_date_selected.connect(set_todo_date)

func add_todo():
	var todo = {
		"serial" : app.todo_list.size() + 1,
		"date" : {"year": 2025, "month": 1, "day": 1},
		"msg": todo_input.text
	}
	prints("Add new todo", todo)
	emit_signal("_on_todo_added", todo)
	todo_input.clear()

func _on_add_btn_pressed() -> void:
	add_todo()

func _on_date_button_pressed() -> void:
	Calendar.show()

func set_todo_date(date : Dictionary):
	todo_date = date
	todo_date.text = "%d-%d-%d" %[todo_date["year"], todo_date["month"], todo_date["day"]]
	
