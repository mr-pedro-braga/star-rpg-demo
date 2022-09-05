@tool
extends EditorPlugin

const dock_scene = preload("res://addons/star_dock_file_editor/file_editor_dock.tscn")
var dock = dock_scene.instantiate()

func _enter_tree():
	add_control_to_bottom_panel(dock, "File Editor")

func _exit_tree():
	remove_control_from_bottom_panel(dock)
