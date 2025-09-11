extends PanelContainer
class_name TodoItem

@export var id_label : Label
@export var content_label : Label
@export var due_label : Label
@export var complete_btn : Button
@export var remove_btn : Button
var todo : Dictionary = {
	"id": 0,
	"msg": "",
	"duetime": {"year": 0, "month": 0, "day": 0}
}
signal _on_todo_removed
signal _on_todo_completed
signal _on_todo_canceled
var overdue : bool = false

func set_todo(todo_data : Dictionary):
	todo = todo_data
	id_label.text = str(todo["id"]) + "."
	content_label.text = todo["msg"]
	due_label.text = "　期限: %d-%02d-%02d" %[todo["duetime"]["year"], todo["duetime"]["month"], todo["duetime"]["day"]]

func _on_remove_btn_pressed() -> void:
	emit_signal("_on_todo_removed", todo["id"])

# Toggle completion or cancelation.
func _on_complete_btn_toggled(toggled_on: bool) -> void:
	# Completed
	if (toggled_on):
		modulate = Color(0.7, 0.7, 0.7, 1)
		complete_btn.text = "取消"
		emit_signal("_on_todo_completed", todo["id"])
	else:
		modulate = Color(1, 1, 1, 1)
		complete_btn.text = "完成"
		emit_signal("_on_todo_canceled", todo["id"])

##TODO MAKE IT JUST RETURN TRUE OR FALSE
# Check if todo is overdue.
func is_overdue():
	var date = Time.get_datetime_dict_from_system()
	if (date["year"] < todo["duetime"].get("year", 0)):
		return false
	if (date["month"] < todo["duetime"].get("month", 0)):
		return false
	if (date["month"] == todo["duetime"].get("month", 0)):
		if (date["day"] <= todo["duetime"].get("day", 0)):
			return false
	content_label.add_theme_color_override("font_color", "#ff0000")
	overdue = true
	%Timer.stop()

func _on_timer_timeout() -> void:
	is_overdue()
