@tool
extends EditorInspectorPlugin

var editor_plugin: EditorPlugin
var confirm_dialog: ConfirmationDialog
var pending_trigger: MEFEventTrigger


func _can_handle(object):
	return object is MEFEventTrigger


func _parse_begin(object):

	var button := Button.new()
	button.text = "Apply MEF Preset"

	button.pressed.connect(func():
		pending_trigger = object
		_show_confirmation(object)
	)

	add_custom_control(button)


func _show_confirmation(trigger: MEFEventTrigger) -> void:

	if not confirm_dialog:
		confirm_dialog = ConfirmationDialog.new()
		confirm_dialog.title = "Apply MEF Preset"

		editor_plugin.get_editor_interface().get_base_control().add_child(confirm_dialog)

		confirm_dialog.confirmed.connect(func():
			if pending_trigger:
				_apply_preset_with_undo(pending_trigger)
				pending_trigger = null
		)

	if _has_non_restorable_children(trigger):
		confirm_dialog.dialog_text = (
			"Some nodes were created manually and cannot be restored by Undo.
			This will replace all current Conditions and Effects.
			Continue anyway?"
		)
	else:
		confirm_dialog.dialog_text = (
			"This will replace all current Conditions and Effects.
			This action can be undone."
		)

	confirm_dialog.popup_centered()


func _apply_preset_with_undo(trigger: MEFEventTrigger) -> void:

	if not trigger.preset:
		return

	var undo_redo: EditorUndoRedoManager = editor_plugin.get_undo_redo()

	undo_redo.create_action("Apply MEF Preset")

	var old_condition_paths: Array[String] = []
	var old_effect_paths: Array[String] = []

	for child in trigger.get_children():
		if child is MEFCondition:
			if child.scene_file_path != "":
				old_condition_paths.append(child.scene_file_path)
		elif child is MEFEffect:
			if child.scene_file_path != "":
				old_effect_paths.append(child.scene_file_path)

	undo_redo.add_do_method(
		trigger,
		"_apply_preset_internal",
		trigger.preset
	)

	undo_redo.add_undo_method(
		trigger,
		"_restore_from_scene_paths",
		old_condition_paths,
		old_effect_paths
	)

	undo_redo.commit_action()


func _has_non_restorable_children(trigger: MEFEventTrigger) -> bool:
	for child in trigger.get_children():
		if child is MEFCondition or child is MEFEffect:
			if child.scene_file_path == "":
				return true
	return false
