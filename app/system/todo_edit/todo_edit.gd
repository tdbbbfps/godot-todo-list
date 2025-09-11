extends HBoxContainer
class_name TodoEdit

@export var app : App
@export var todo_input : LineEdit
@export var add_btn : Button
@export var date_btn : Button
signal _on_todo_added
var target_duetime : Dictionary = {"year" : 0, "month" : 0, "day": 0}

func _ready() -> void:
	Calendar._on_date_selected.connect(set_todo_duetime)
	set_today()
	
# Set target date to today.
func set_today():
	var current_duetime = Time.get_datetime_dict_from_system()
	target_duetime = {
		"year": current_duetime["year"],
		"month": current_duetime["month"],
		"day": current_duetime["day"]
	}
	update_date_display()

# Update target date display.
func update_date_display():
	date_btn.text = "%d-%02d-%02d" %[target_duetime["year"], target_duetime["month"], target_duetime["day"]]
# Add new todo.
func add_todo():
	if (todo_input.text.is_empty()):
		printerr("Todo content can't be empty!")
		return
	var todo = {
		"duetime" : target_duetime,
		"msg": todo_input.text,
		"completed" : false
	}
	emit_signal("_on_todo_added", todo)
	todo_input.clear()

func _on_add_btn_pressed() -> void:
	add_todo()

func _on_date_button_pressed() -> void:
	Calendar.ui.show()

# Set todo's target date.
func set_todo_duetime(duetime : Dictionary):
	target_duetime = duetime
	update_date_display()

func _on_todo_input_text_submitted(new_text: String) -> void:
	add_todo()
