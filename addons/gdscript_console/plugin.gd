tool
extends EditorPlugin

var console = preload("res://addons/gdscript_console/console.tscn").instance()

func _enter_tree() -> void:
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, console)
	
func _exit_tree() -> void:
	remove_control_from_docks(console)
	console.queue_free()
	
