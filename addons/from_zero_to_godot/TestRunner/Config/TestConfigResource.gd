@tool
extends Resource
class_name TestConfigResource

const TYPE_FUNCTION := "function"
const TYPE_FUNCTION_GROUP := "function_group"
const TYPE_CLASS := "class"
const TYPE_CLASS_CUSTOM := "class_custom"
const TYPE_SCENE := "scene"

const COMPARISON_EXACT := "exact"
const COMPARISON_APPROXIMATE := "approximate"

var source_path: String = ""
var type: String = TYPE_FUNCTION
var function_name: String = ""
var functions: Array[TestFunctionConfig] = []
var name_class: String = ""
var scene_path: String = ""
var test_file: String = ""
var timeout_ms: int = 1000
var comparison: String = COMPARISON_EXACT
var tolerance: float = 0.01
var cases: Array[TestCaseConfig] = []
var methods: Array[TestMethodConfig] = []

func get_target_name() -> String:
	if not function_name.is_empty():
		return function_name
	if not functions.is_empty():
		return ", ".join(get_function_names())
	return name_class

func get_function_names() -> Array[String]:
	var names: Array[String] = []
	for function_config in functions:
		if not function_config.function_name.is_empty():
			names.append(function_config.function_name)
	return names

func to_dictionary() -> Dictionary:
	var data := {
		TestConfigKeys.TYPE: type,
		TestConfigKeys.TIMEOUT: timeout_ms,
		TestConfigKeys.COMPARISON: comparison,
		TestConfigKeys.TOLERANCE: tolerance
	}

	if not function_name.is_empty():
		data[TestConfigKeys.FUNCTION] = function_name

	var serialized_functions: Array = []
	for function_config in functions:
		serialized_functions.append(function_config.to_dictionary())
	if not serialized_functions.is_empty():
		data[TestConfigKeys.FUNCTIONS] = serialized_functions

	if not name_class.is_empty():
		data[TestConfigKeys.CLASS] = name_class
	if not scene_path.is_empty():
		data[TestConfigKeys.SCENE_PATH] = scene_path
	if not test_file.is_empty():
		data[TestConfigKeys.TEST_FILE] = test_file

	var serialized_cases: Array = []
	for case_config in cases:
		serialized_cases.append(case_config.to_dictionary())
	if not serialized_cases.is_empty():
		data[TestConfigKeys.CASES] = serialized_cases

	var serialized_methods: Array = []
	for method_config in methods:
		serialized_methods.append(method_config.to_dictionary())
	if not serialized_methods.is_empty():
		data[TestConfigKeys.METHODS] = serialized_methods

	return data
