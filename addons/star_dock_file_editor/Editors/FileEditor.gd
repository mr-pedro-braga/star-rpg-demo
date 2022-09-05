
@tool
extends Node
class_name FileEditor

var save_path : String = ""
var f = File.new()

func load_from_path(path):
	save_path = path
	f.open(path, File.READ_WRITE)
	var t = f.get_as_text()
	f.close()
	return t

func save(path=""):
	if path == "" and not save_path == "":
		save(save_path)
		return
	print("Attempting to save at ", path)
	save_path = path

func close():
	f.close()
