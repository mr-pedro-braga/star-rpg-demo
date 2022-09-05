@tool
extends Control

var open_documents : Array = []

@export var extensions := {}

@export var editors := {}

func _ready():
	var popup := ($V/H/BtnFile as MenuButton).get_popup()
	popup.connect("id_pressed", on_file_id_pressed)

enum {
	NEW, OPEN, SAVE, SAVE_AS, CLOSE
}

func on_file_id_pressed(id):
	match id:
		NEW:
			new()
		OPEN:
			open()
		SAVE:
			save()
		SAVE_AS:
			save_as()
		CLOSE:
			close()

func new():
	var control = editors["StarScript"].instantiate()
	var tl = ($V/TabList as ItemList)
	var tc = ($M/TabContainer as TabContainer)
	
	tl.add_item("New Star Script")
	tc.add_child(control)

func open():
	var fd = ($FileDialog as FileDialog)
	fd.file_mode = FileDialog.FILE_MODE_OPEN_FILES
	fd.popup_centered(Vector2i(600, 600))

func save():
	var tc = ($M/TabContainer as TabContainer)
	var control = tc.get_current_tab_control()
	
	if control.save_path == "":
		save_as()
		return
	control.save(control.save_path)

func save_as():
	var fd = ($FileDialog as FileDialog)
	fd.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	fd.popup_centered(Vector2i(600, 600))

func close():
	var tl = ($V/TabList as ItemList)
	var tc = ($M/TabContainer as TabContainer)
	var control = tc.get_current_tab_control()
	var index = tc.get_tab_idx_from_control(control)
	
	control.close()
	control.queue_free()
	tl.remove_item(index)
	if tl.item_count > 0: tl.select(index - 1)

func _on_file_selected(path):
	var fd = ($FileDialog as FileDialog)
	match fd.file_mode:
		FileDialog.FILE_MODE_SAVE_FILE:
			var tl = ($V/TabList as ItemList)
			var tc = ($M/TabContainer as TabContainer)
			var control = tc.get_current_tab_control()
			if tc == null:
				return
			var index = tc.get_tab_idx_from_control(control)
			
			control.save(path)
			tl.set_item_text(index, control.save_path.get_file().get_basename())

func _on_files_selected(paths):
	var fd = ($FileDialog as FileDialog)
	for path in paths:
		var extension = (path as String).get_extension()
		var file_name = (path as String).get_file().get_basename()
		var control = editors[extensions[extension]].instantiate()
		
		var tl = ($V/TabList as ItemList)
		var tc = ($M/TabContainer as TabContainer)
		
		tl.add_item(file_name)
		tc.add_child(control)

		control.load_from_path(path)
		tl.select(tl.item_count - 1)
		_on_tab_selected(tl.item_count - 1)

func _on_tab_selected(index):
	($M/TabContainer as TabContainer).current_tab = index
