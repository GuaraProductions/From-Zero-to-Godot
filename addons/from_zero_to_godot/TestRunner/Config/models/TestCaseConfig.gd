@tool
extends Resource
class_name TestCaseConfig

var name: String = ""
var method: String = ""
var name_class: String = ""
var constructor_params: Array = []
var setup_calls: Array = []
var input: Array = []
var expected_output = null
var actual_output = null
var properties: Dictionary = {}
var validate = null

func to_dictionary() -> Dictionary:
	var data := {
		TestConfigKeys.NAME: name,
		TestConfigKeys.INPUT: input.duplicate(true),
		TestConfigKeys.CONSTRUCTOR_PARAMS: constructor_params.duplicate(true),
		TestConfigKeys.SETUP_CALLS: setup_calls.duplicate(true),
		TestConfigKeys.PROPERTIES: properties.duplicate(true)
	}

	if not method.is_empty():
		data[TestConfigKeys.METHOD] = method
	if not name_class.is_empty():
		data[TestConfigKeys.CLASS] = name_class
	if expected_output != null:
		data[TestConfigKeys.EXPECTED_OUTPUT] = expected_output
	if actual_output != null:
		data[TestConfigKeys.ACTUAL_OUTPUT] = actual_output
	if validate != null:
		data[TestConfigKeys.VALIDATE] = validate

	return data
