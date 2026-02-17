extends RefCounted
class_name MEFTemplateLoader


static func load_template(path: String) -> String:

	if not FileAccess.file_exists(path):
		push_error("MEF: Template not found: %s" % path)
		return ""

	var file := FileAccess.open(path, FileAccess.READ)
	var content := file.get_as_text()
	file.close()

	return content
