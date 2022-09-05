@tool
extends EditorPlugin

# Import Plugins!
var star_script_importer
var sprite_sheet_importer

func _enter_tree():
	setup()

	# Add import plugins!
	star_script_importer = preload("star_script_importer.gd").new()
	add_import_plugin(star_script_importer)
	
	sprite_sheet_importer = preload("sprite_sheet_importer.gd").new()
	add_import_plugin(sprite_sheet_importer)

# Might do extra stuff like change some Project Settings!
func setup():
	pass

func _exit_tree():
	# Remove import plugins!
	remove_import_plugin(star_script_importer)
	star_script_importer = null
	
	remove_import_plugin(sprite_sheet_importer)
	sprite_sheet_importer = null
