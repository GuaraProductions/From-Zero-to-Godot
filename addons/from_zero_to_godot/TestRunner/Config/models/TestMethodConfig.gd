@tool
extends Resource
class_name TestMethodConfig

var name: String = ""
var comparison: String = "exact"
var tolerance: float = 0.01
var cases: Array[TestCaseConfig] = []

func to_dictionary() -> Dictionary:
	var serialized_cases: Array = []
	for case_config in cases:
		serialized_cases.append(case_config.to_dictionary())

	return {
		TestConfigKeys.NAME: name,
		TestConfigKeys.COMPARISON: comparison,
		TestConfigKeys.TOLERANCE: tolerance,
		TestConfigKeys.CASES: serialized_cases
	}
