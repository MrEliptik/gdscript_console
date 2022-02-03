tool
extends Control

onready var editor = $VBoxContainer/VSplitContainer/Editor
onready var output = $VBoxContainer/VSplitContainer/VBoxContainer/Result

onready var expression = Expression.new()

onready var root_node = get_tree().get_edited_scene_root()

var plugin: EditorPlugin setget set_plugin, get_plugin
var curr_script: Script
var curr_node = null

var code_font: DynamicFont

# Used to zoom in and out
var ctrl_pressed: bool = false

func _ready() -> void:
	$VBoxContainer/HBoxContainer/Message.text = ""
	# TODO: change font size to the same as the editor
	output.add_keyword_color("ERROR", Color(1.0, 0.0, 0.0))
	
func set_plugin(val) -> void:
	plugin = val
	plugin.connect("script_changed_to", self, "on_script_changed")
	
func get_plugin() -> EditorPlugin:
	return plugin

func _on_Run_pressed() -> void:
	root_node = get_tree().get_edited_scene_root()
	var txt = editor.text
	var lines = txt.split("\n")
	for line in lines:
		var error = expression.parse(line, [])
		if error != OK:
			var err_txt = expression.get_error_text()
			output.text += "ERROR: " + err_txt + "\n"
			return
#		result = expression.execute([], root_node, true)
#		result = expression.execute([], curr_script, true)
		var result = expression.execute([], curr_node, true)
			
		if not expression.has_execute_failed():
			output.text += str(result) + "\n"
			

func _on_Clear_pressed() -> void:
	output.text = ""

func _on_Editor_text_changed() -> void:
	pass

func _on_Editor_request_completion() -> void:
	pass

func on_script_changed(script: Script) -> void:
	curr_script = script
#	curr_node = script.get_local_scene()
	if curr_node:
		curr_node.free()
	curr_node = script.new()
	
	if !curr_script.is_tool():
		$VBoxContainer/HBoxContainer/Message.text = "CAREFUL! Script is not a tool. Calling its functions isn't possible."
	else:
		$VBoxContainer/HBoxContainer/Message.text = ""

func _on_Editor_gui_input(event: InputEvent) -> void:
	# Handle ctrl + zoom
	if event is InputEventKey:
		if event.scancode == KEY_CONTROL:
			ctrl_pressed = event.is_pressed()
	
	elif event is InputEventMouseButton:
		if event.is_pressed() and ctrl_pressed:
			if event.button_index == BUTTON_WHEEL_UP:
				code_font.size += 1
			elif event.button_index == BUTTON_WHEEL_DOWN:
				code_font.size -= 1
