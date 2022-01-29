tool
extends Control

onready var editor = $VSplitContainer/Editor
onready var output = $VSplitContainer/VBoxContainer/Result

onready var expression = Expression.new()

onready var root_node = get_tree().get_edited_scene_root()

func _ready() -> void:
	# TODO: change font size to the same as the editor
	output.add_keyword_color("ERROR", Color(1.0, 0.0, 0.0))

func _on_Run_pressed() -> void:
	root_node = get_tree().get_edited_scene_root()
	print(root_node)
	var txt = editor.text
	var lines = txt.split("\n")
	for line in lines:
		var error = expression.parse(line, [])
		if error != OK:
			# TODO: print the err to the output console, but in red
			var err_txt = expression.get_error_text()
#			output.add_color_region(err_txt.substr(0, 1), "\n", Color(1.0, 0.0, 0.0), false)
			output.text += "ERROR: " + err_txt + "\n"
			return
		var result = expression.execute([], root_node, true)
		if not expression.has_execute_failed():
			output.text += str(result) + "\n"
			

func _on_Clear_pressed() -> void:
	output.text = ""

func _on_Editor_text_changed() -> void:
	pass

func _on_Editor_request_completion() -> void:
	pass
