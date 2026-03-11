@tool
extends SceneTree

const JSON_FILE_NAMES := {
	"tests.json": true,
	"tests_config.json": true
}

func _init() -> void:
	var root_path = _resolve_exercises_root()
	if root_path.is_empty():
		push_error("Exercises directory not found. Expected res://exercises-lists or res://exercises_lists")
		quit(1)
		return

	var updated_files = _normalize_directory(root_path)
	print("Normalized %d test JSON file(s) under %s" % [updated_files, root_path])
	quit()

func _resolve_exercises_root() -> String:
	var candidates = ["res://exercises-lists", "res://exercises_lists"]
	for candidate in candidates:
		if DirAccess.dir_exists_absolute(candidate):
			return candidate
	return ""

func _normalize_directory(directory_path: String) -> int:
	var updated_files = 0
	var dir = DirAccess.open(directory_path)
	if not dir:
		push_error("Failed to open directory: %s" % directory_path)
		return 0

	dir.list_dir_begin()
	var entry = dir.get_next()
	while not entry.is_empty():
		if entry == "." or entry == "..":
			entry = dir.get_next()
			continue

		var entry_path = directory_path.path_join(entry)
		if dir.current_is_dir():
			updated_files += _normalize_directory(entry_path)
		elif JSON_FILE_NAMES.has(entry):
			updated_files += _normalize_json_file(entry_path)

		entry = dir.get_next()

	dir.list_dir_end()
	return updated_files

func _normalize_json_file(file_path: String) -> int:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("Failed to open JSON file: %s" % file_path)
		return 0

	var original_text = file.get_as_text()
	file.close()

	var json = JSON.new()
	var parse_result = json.parse(original_text)
	if parse_result != OK:
		push_error("Failed to parse JSON file %s: %s" % [file_path, json.get_error_message()])
		return 0

	if not json.data is Dictionary:
		return 0

	var normalized = TestConfigKeys.normalize_dictionary(json.data)
	var normalized_text = JSON.stringify(normalized, "\t") + "\n"
	if normalized_text == original_text:
		return 0

	file = FileAccess.open(file_path, FileAccess.WRITE)
	if not file:
		push_error("Failed to write normalized JSON file: %s" % file_path)
		return 0

	file.store_string(normalized_text)
	file.close()
	return 1