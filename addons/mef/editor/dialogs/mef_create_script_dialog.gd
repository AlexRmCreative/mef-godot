@tool
extends AcceptDialog
class_name MEFCreateScriptDialog


var type_option: OptionButton
var browse_button: Button
var initial_path: String = "res://"
var name_edit: LineEdit
var path_edit: LineEdit


func _ready() -> void:
	title = "Create MEF Script"
	ok_button_text = "Create"
	min_size = Vector2(600, 200)

	var root := VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(root)

	# Script type
	var type_label := Label.new()
	type_label.text = "Script Type"
	root.add_child(type_label)

	type_option = OptionButton.new()
	type_option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	type_option.add_item("MEF Effect")
	type_option.add_item("MEF Condition")
	root.add_child(type_option)

	# Name
	var name_label := Label.new()
	name_label.text = "Name"
	root.add_child(name_label)

	name_edit = LineEdit.new()
	name_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_child(name_edit)

	# Folder
	var path_label := Label.new()
	path_label.text = "Folder"
	root.add_child(path_label)

	var path_row := HBoxContainer.new()
	path_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_child(path_row)

	path_edit = LineEdit.new()
	path_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	path_edit.text = initial_path
	path_row.add_child(path_edit)

	browse_button = Button.new()
	browse_button.text = "Browse"
	browse_button.pressed.connect(_on_browse_pressed)
	path_row.add_child(browse_button)

	confirmed.connect(_on_confirmed)

	_update_default_name()
	type_option.item_selected.connect(_update_default_name)


func _on_browse_pressed() -> void:
	var dialog := EditorFileDialog.new()
	dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_DIR
	dialog.access = EditorFileDialog.ACCESS_RESOURCES
	dialog.current_path = path_edit.text

	dialog.dir_selected.connect(func(path: String):
		path_edit.text = path
	)

	add_child(dialog)
	dialog.popup_centered()


func _on_confirmed() -> void:
	var folder := path_edit.text.strip_edges()
	var name := name_edit.text.strip_edges()

	if folder == "" or name == "":
		return

	if not name.ends_with(".gd"):
		name += ".gd"

	var full_path := folder.path_join(name)

	if FileAccess.file_exists(full_path):
		push_warning("File already exists")
		return

	var template_path := ""
	match type_option.selected:
		0:
			template_path = "res://addons/mef/editor/templates/mef_effect_template.gd"
		1:
			template_path = "res://addons/mef/editor/templates/mef_condition_template.gd"

	var content := MEFTemplateLoader.load_template(template_path)
	if content.is_empty():
		return

	var file := FileAccess.open(full_path, FileAccess.WRITE)
	file.store_string(content)
	file.close()

	EditorInterface.get_resource_filesystem().scan()
	EditorInterface.edit_resource(load(full_path))


func _update_default_name(_index := 0) -> void:
	match type_option.selected:
		0:
			name_edit.text = "mef_effect.gd"
		1:
			name_edit.text = "mef_condition.gd"
