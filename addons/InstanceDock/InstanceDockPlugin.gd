@tool
extends EditorPlugin

var dock: Control

func _enter_tree():
	dock = preload("res://addons/InstanceDock/InstanceDock.tscn").instantiate()
	dock.plugin = self
	add_control_to_bottom_panel(dock, "Instances")

func _exit_tree():
	remove_control_from_bottom_panel(dock)
	dock.free()
