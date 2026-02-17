@tool
extends EditorPlugin

var inspector_plugin: EditorInspectorPlugin
var fs_context_menu: EditorContextMenuPlugin


func _enter_tree() -> void:

	# -------------------------
	# Inspector
	# -------------------------
	inspector_plugin = preload(
		"res://addons/mef/editor/inspector/mef_event_trigger_inspector.gd"
	).new()

	inspector_plugin.editor_plugin = self
	add_inspector_plugin(inspector_plugin)


	# -------------------------
	# FileSystem Context Menu
	# -------------------------
	fs_context_menu = preload(
		"res://addons/mef/editor/context_menu/mef_filesystem_context.gd"
	).new()

	add_context_menu_plugin(
		EditorContextMenuPlugin.CONTEXT_SLOT_FILESYSTEM_CREATE,
		fs_context_menu
	)


func _exit_tree() -> void:

	if inspector_plugin:
		remove_inspector_plugin(inspector_plugin)
		inspector_plugin = null

	if fs_context_menu:
		remove_context_menu_plugin(fs_context_menu)
		fs_context_menu = null
