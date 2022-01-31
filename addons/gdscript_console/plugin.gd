tool
extends EditorPlugin

signal script_changed_to(script)

var console = preload("res://addons/gdscript_console/console.tscn").instance()
var curr_script: Script

func _enter_tree() -> void:
	# Update font
	var code_font: DynamicFont = load("res://addons/gdscript_console/fonts/code_font.tres")
	code_font.size = get_editor_interface().get_editor_settings().get_setting("interface/editor/code_font_size")
	
	get_editor_interface().get_script_editor().connect("editor_script_changed", self, "on_editor_scrip_changed")
	curr_script = get_editor_interface().get_script_editor().get_current_script()
	
	console.plugin = self
	console.curr_script = curr_script
	console.curr_node = curr_script.new()
	console.code_font = code_font
	
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, console)
	
func _exit_tree() -> void:
	remove_control_from_docks(console)
	console.curr_node.free()
	console.free()
	
func on_editor_scrip_changed(script: Script) -> void:
	curr_script = script
	emit_signal("script_changed_to", curr_script)
