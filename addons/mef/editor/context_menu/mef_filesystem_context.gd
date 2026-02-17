@tool
extends EditorContextMenuPlugin
class_name MEFFilesystemContextMenu


func _popup_menu(paths: PackedStringArray) -> void:

	var icon = null

	if paths.is_empty():
		add_context_menu_item(
			"New MEF Script...",
			_create_script,
			icon
		)
	else:
		add_context_menu_item(
			"Create MEF Script...",
			_create_script,
			icon
		)


func _create_script(paths: PackedStringArray) -> void:
	_open_dialog(paths)


func _open_dialog(paths: PackedStringArray) -> void:

	var dialog := MEFCreateScriptDialog.new()

	if not paths.is_empty():
		dialog.initial_path = paths[0]

	EditorInterface.get_base_control().add_child(dialog)
	dialog.popup_centered()
