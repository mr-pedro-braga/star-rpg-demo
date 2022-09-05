@tool
extends FileEditor
class_name StarScriptEditor

@onready var code := get_node("T/Script")
@onready var dialog_text := get_node("T/Preview/V/DialogBox/V/DialogText")
@onready var output := get_node("T/Preview/V/M/Output")
@onready var shell = get_node("T/Preview/Node/Shell")
var prev_script : StarScript
var prev_key : String = "meta"

func _ready():
	shell.dialog_box = dialog_text
	shell.output = output

func connect_if_not_already(sig, callback):
	if not sig.is_connected(callback):
		sig.connect(callback)

func load_from_path(path):
	code.text = super(path)

func save(path=""):
	super(path)
	if path == "": return
	
	f.open(path, File.WRITE)
	f.store_string(code.text)
	f.close()

func parse_code():
	var raw = code.text
	var s = StarScriptParser.parse(raw)
	prev_script = StarScript.new()
	prev_script.data = s
	prev_script.source_code = raw
	var popup : PopupMenu = $%SectionList.get_popup()
	popup.clear()
	
	for i in prev_script.data.data.keys():
		popup.add_item(i)
	
	%SectionList.selected = 0

func preview():
	if not prev_script.data.data.has(prev_key):
		shell.print_err("MissingSectionError", "No such key as '" + prev_key + "'.")
		return
	var e = prev_script.data.data[prev_key].content
	output.text = ""
	shell.execute_block(e)

func _on_tab_changed(tab):
	match tab:
		1:
			parse_code()

func _on_preview_pressed():
	preview()

func _on_preview_section_selected(index):
	var popup : PopupMenu = $%SectionList.get_popup()
	prev_key = popup.get_item_text(index)
