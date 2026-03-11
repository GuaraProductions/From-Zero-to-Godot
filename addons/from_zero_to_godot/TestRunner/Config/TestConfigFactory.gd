@tool
extends RefCounted
class_name TestConfigFactory

static func load_from_json(json_path: String) -> TestConfigResource:
	if not FileAccess.file_exists(json_path):
		push_error("Test configuration file not found: %s" % json_path)
		return null

	var file = FileAccess.open(json_path, FileAccess.READ)
	if not file:
		push_error("Failed to open test configuration file: %s" % json_path)
		return null

	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		push_error("Failed to parse test configuration JSON: %s" % json.get_error_message())
		return null

	if not json.data is Dictionary:
		push_error("Test configuration root must be a Dictionary: %s" % json_path)
		return null

	return from_dictionary(json.data, json_path)

static func from_dictionary(data: Dictionary, source_path: String = "") -> TestConfigResource:
	var normalized = TestConfigKeys.normalize_dictionary(data)
	var config = TestConfigResource.new()
	config.source_path = source_path
	config.type = str(normalized.get(TestConfigKeys.TYPE, TestConfigResource.TYPE_FUNCTION))
	if config.type == TestConfigResource.TYPE_FUNCTION and normalized.has(TestConfigKeys.FUNCTIONS):
		config.type = TestConfigResource.TYPE_FUNCTION_GROUP
	config.function_name = str(normalized.get(TestConfigKeys.FUNCTION, ""))
	config.name_class = str(normalized.get(TestConfigKeys.CLASS, ""))
	config.scene_path = str(normalized.get(TestConfigKeys.SCENE_PATH, ""))
	config.test_file = str(normalized.get(TestConfigKeys.TEST_FILE, ""))
	config.timeout_ms = _normalize_timeout_ms(normalized.get(TestConfigKeys.TIMEOUT, 1000), config.type)
	config.comparison = str(normalized.get(TestConfigKeys.COMPARISON, TestConfigResource.COMPARISON_EXACT))
	config.tolerance = float(normalized.get(TestConfigKeys.TOLERANCE, 0.01))

	for raw_function in normalized.get(TestConfigKeys.FUNCTIONS, []):
		if raw_function is Dictionary:
			config.functions.append(_create_function(raw_function, config.comparison, config.tolerance))

	for raw_case in normalized.get(TestConfigKeys.CASES, []):
		if raw_case is Dictionary:
			config.cases.append(_create_case(raw_case))

	for raw_method in normalized.get(TestConfigKeys.METHODS, []):
		if raw_method is Dictionary:
			config.methods.append(_create_method(raw_method))

	if config.name_class.is_empty() and config.type == TestConfigResource.TYPE_CLASS_CUSTOM and not config.cases.is_empty():
		config.name_class = config.cases[0].name_class

	return config

static func load_custom_cases(script_path: String) -> Array[TestCaseConfig]:
	var script_testes = load(script_path)
	if not script_testes:
		push_error("Failed to load custom test script: %s" % script_path)
		return []

	var instancia_testes = script_testes.new()
	var metodo_carregamento = ""
	if instancia_testes.has_method("get_test_cases"):
		metodo_carregamento = "get_test_cases"
	elif instancia_testes.has_method("get_casos_teste"):
		metodo_carregamento = "get_casos_teste"
	else:
		push_error("Custom test script must expose get_test_cases() or get_casos_teste()")
		instancia_testes.free()
		return []

	var raw_cases = instancia_testes.call(metodo_carregamento)
	var cases: Array[TestCaseConfig] = []
	if raw_cases is Array:
		for raw_case in raw_cases:
			if raw_case is Dictionary:
				cases.append(_create_case(TestConfigKeys.normalize_dictionary(raw_case)))

	instancia_testes.free()
	return cases

static func _create_case(data: Dictionary) -> TestCaseConfig:
	var case_config = TestCaseConfig.new()
	case_config.name = str(data.get(TestConfigKeys.NAME, ""))
	case_config.method = str(data.get(TestConfigKeys.METHOD, ""))
	case_config.name_class = str(data.get(TestConfigKeys.CLASS, ""))
	case_config.constructor_params = _ensure_array(data.get(TestConfigKeys.CONSTRUCTOR_PARAMS, []))
	case_config.setup_calls = _ensure_array(data.get(TestConfigKeys.SETUP_CALLS, []))
	case_config.input = _ensure_array(data.get(TestConfigKeys.INPUT, []))
	case_config.expected_output = data.get(TestConfigKeys.EXPECTED_OUTPUT)
	case_config.actual_output = data.get(TestConfigKeys.ACTUAL_OUTPUT)
	case_config.properties = data.get(TestConfigKeys.PROPERTIES, {})
	case_config.validate = data.get(TestConfigKeys.VALIDATE)
	return case_config

static func _create_method(data: Dictionary) -> TestMethodConfig:
	var method_config = TestMethodConfig.new()
	method_config.name = str(data.get(TestConfigKeys.NAME, ""))
	method_config.comparison = str(data.get(TestConfigKeys.COMPARISON, TestConfigResource.COMPARISON_EXACT))
	method_config.tolerance = float(data.get(TestConfigKeys.TOLERANCE, 0.01))
	for raw_case in data.get(TestConfigKeys.CASES, []):
		if raw_case is Dictionary:
			method_config.cases.append(_create_case(raw_case))
	return method_config

static func _create_function(data: Dictionary, default_comparison: String, default_tolerance: float) -> TestFunctionConfig:
	var function_config = TestFunctionConfig.new()
	function_config.function_name = str(data.get(TestConfigKeys.FUNCTION, ""))
	function_config.comparison = str(data.get(TestConfigKeys.COMPARISON, default_comparison))
	function_config.tolerance = float(data.get(TestConfigKeys.TOLERANCE, default_tolerance))
	for raw_case in data.get(TestConfigKeys.CASES, []):
		if raw_case is Dictionary:
			function_config.cases.append(_create_case(raw_case))
	return function_config

static func _ensure_array(value) -> Array:
	if value is Array:
		return value.duplicate(true)
	if value == null:
		return []
	return [value]

static func _normalize_timeout_ms(raw_timeout, test_type: String) -> int:
	var timeout_value := int(raw_timeout)
	if timeout_value <= 0:
		return 1000

	# Legacy function JSONs used seconds while class-based runners already treat timeout as ms.
	if (test_type == TestConfigResource.TYPE_FUNCTION or test_type == TestConfigResource.TYPE_FUNCTION_GROUP) and timeout_value <= 60:
		return timeout_value * 1000

	return timeout_value
