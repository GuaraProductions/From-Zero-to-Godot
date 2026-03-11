extends Node

const SOURCE_ROOT := "res://exercises-lists/en"
const DESTINATION_ROOT := "res://exercises-testing"
const DELETE_SOURCE_AFTER_COPY := false
const JSON_FILE_NAME := "tests.json"
const CUSTOM_TEST_FILE_NAMES := [
	"tests_custom.gd",
	"test_custom.gd"
]

func _ready():
	if not DirAccess.dir_exists_absolute(SOURCE_ROOT):
		push_error("Source directory not found: %s" % SOURCE_ROOT)
		get_tree().quit(1)
		return

	_ensure_directory(DESTINATION_ROOT)

	var migration_summary = _migrate_root()
	print("Migrated %d test JSON file(s) and %d custom test script(s) to %s" % [
		migration_summary.json_files,
		migration_summary.custom_files,
		DESTINATION_ROOT
	])

	if not migration_summary.errors.is_empty():
		push_warning("Migration finished with %d warning(s):\n%s" % [
			migration_summary.errors.size(),
			"\n".join(migration_summary.errors)
		])
	
func _migrate_root() -> Dictionary:
	var summary := {
		"json_files": 0,
		"custom_files": 0,
		"errors": []
	}

	var dir = DirAccess.open(SOURCE_ROOT)
	if not dir:
		summary.errors.append("Failed to open source root: %s" % SOURCE_ROOT)
		return summary

	dir.list_dir_begin()
	var list_name = dir.get_next()
	while not list_name.is_empty():
		if list_name in [".", ".."]:
			list_name = dir.get_next()
			continue

		if dir.current_is_dir():
			_merge_summary(summary, _migrate_list(list_name))

		list_name = dir.get_next()

	dir.list_dir_end()
	return summary

func _migrate_list(list_name: String) -> Dictionary:
	var summary := {
		"json_files": 0,
		"custom_files": 0,
		"errors": []
	}

	var list_path = SOURCE_ROOT.path_join(list_name)
	var dir = DirAccess.open(list_path)
	if not dir:
		summary.errors.append("Failed to open list directory: %s" % list_path)
		return summary

	dir.list_dir_begin()
	var exercise_name = dir.get_next()
	while not exercise_name.is_empty():
		if exercise_name in [".", ".."]:
			exercise_name = dir.get_next()
			continue

		if dir.current_is_dir():
			_merge_summary(summary, _migrate_exercise(list_name, exercise_name))

		exercise_name = dir.get_next()

	dir.list_dir_end()
	return summary

func _migrate_exercise(list_name: String, exercise_name: String) -> Dictionary:
	var summary := {
		"json_files": 0,
		"custom_files": 0,
		"errors": []
	}

	var source_dir = SOURCE_ROOT.path_join(list_name).path_join(exercise_name)
	var destination_dir = DESTINATION_ROOT.path_join(list_name).path_join(exercise_name)
	_ensure_directory(destination_dir)

	var source_json_path = source_dir.path_join(JSON_FILE_NAME)
	if not FileAccess.file_exists(source_json_path):
		return summary

	var custom_file_name = _find_custom_test_file_name(source_dir)
	var destination_custom_path = ""
	if not custom_file_name.is_empty():
		var source_custom_path = source_dir.path_join(custom_file_name)
		destination_custom_path = destination_dir.path_join(custom_file_name)
		var copied = _copy_file(source_custom_path, destination_custom_path)
		if copied:
			summary.custom_files += 1
			if DELETE_SOURCE_AFTER_COPY:
				_remove_file(source_custom_path, summary.errors)
		else:
			summary.errors.append("Failed to copy custom test script: %s" % source_custom_path)

	var migrated_json_text = _build_migrated_json(source_json_path, destination_custom_path, summary.errors)
	if migrated_json_text.is_empty():
		return summary

	var destination_json_path = destination_dir.path_join(JSON_FILE_NAME)
	var file = FileAccess.open(destination_json_path, FileAccess.WRITE)
	if not file:
		summary.errors.append("Failed to write migrated JSON: %s" % destination_json_path)
		return summary

	file.store_string(migrated_json_text)
	file.close()
	summary.json_files += 1

	if DELETE_SOURCE_AFTER_COPY:
		_remove_file(source_json_path, summary.errors)

	return summary

func _build_migrated_json(source_json_path: String, destination_custom_path: String, errors: Array) -> String:
	var file = FileAccess.open(source_json_path, FileAccess.READ)
	if not file:
		errors.append("Failed to open source JSON: %s" % source_json_path)
		return ""

	var original_text = file.get_as_text()
	file.close()

	var json = JSON.new()
	if json.parse(original_text) != OK:
		errors.append("Failed to parse JSON %s: %s" % [source_json_path, json.get_error_message()])
		return ""

	if not json.data is Dictionary:
		errors.append("JSON root must be a Dictionary: %s" % source_json_path)
		return ""

	var migrated_data: Dictionary = json.data.duplicate(true)
	if not destination_custom_path.is_empty():
		if migrated_data.has("arquivo_testes"):
			migrated_data["arquivo_testes"] = destination_custom_path
		if migrated_data.has("test_file"):
			migrated_data["test_file"] = destination_custom_path

	return JSON.stringify(migrated_data, "\t") + "\n"

func _find_custom_test_file_name(source_dir: String) -> String:
	for file_name in CUSTOM_TEST_FILE_NAMES:
		if FileAccess.file_exists(source_dir.path_join(file_name)):
			return file_name
	return ""

func _copy_file(source_path: String, destination_path: String) -> bool:
	var source_file = FileAccess.open(source_path, FileAccess.READ)
	if not source_file:
		return false

	var content = source_file.get_as_text()
	source_file.close()

	var destination_file = FileAccess.open(destination_path, FileAccess.WRITE)
	if not destination_file:
		return false

	destination_file.store_string(content)
	destination_file.close()
	return true

func _ensure_directory(resource_path: String) -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(resource_path))

func _remove_file(path: String, errors: Array) -> void:
	var error_code = DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	if error_code != OK:
		errors.append("Failed to remove source file %s (error %d)" % [path, error_code])

func _merge_summary(target: Dictionary, source: Dictionary) -> void:
	target.json_files += int(source.get("json_files", 0))
	target.custom_files += int(source.get("custom_files", 0))
	for error_text in source.get("errors", []):
		target.errors.append(error_text)
