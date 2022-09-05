@tool
extends EditorImportPlugin



func _get_importer_name():
	return "star.spritesheet"

func _get_visible_name():
	return "Sprite Sheet"

func _get_recognized_extensions():
	return ["ssh", "png", "jpg", "qoi"]

func _get_save_extension():
	return "res"

func _get_resource_type():
	return "Resource"

func _get_preset_count():
	return 1

func _get_import_order():
	return 0

func _get_preset_name(preset):
	return "Default"

func _get_import_options(preset, v):
	return [
		{"name": "frame_size", "default_value": Vector2.ZERO}
	]

func _get_option_visibility(option, option2, options):
	return true

func _import(source_file, save_path, options, r_platform_variants, r_gen_files):
	var image = Image.new()
	var f = File.new()
	f.open(source_file, File.READ)
	image.load_png_from_buffer(f.get_buffer(f.get_length()))
	var t = ImageTexture.create_from_image(image)
	f.close()
	
	var res = SpriteSheet.new()
	res.texture = t
	res.frame_size = options.frame_size

	var r = ResourceSaver.save(res, "%s.%s" % [save_path, _get_save_extension()])
	return r
