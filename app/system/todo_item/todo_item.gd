extends HBoxContainer
class_name TodoItem

@export var serial_num : Label
@export var content : Label
signal _on_todo_removed

func set_todo(todo_info : Dictionary):
	serial_num.text = str(todo_info["serial"])
	content.text = todo_info["msg"] + " 期限: %d-%d-%d" %[todo_info["date"]["year"], todo_info["date"]["month"], todo_info["date"]["day"]]

func _on_complete_btn_pressed() -> void:
	pass # Replace with function body.


func _on_remove_btn_pressed() -> void:
	emit_signal("_on_todo_removed")
	get_parent().remove_child(self)
