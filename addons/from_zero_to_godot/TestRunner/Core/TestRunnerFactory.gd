@tool
extends RefCounted
class_name TestRunnerFactory

const RUNNER_BY_TYPE := {
	TestConfigResource.TYPE_FUNCTION: "res://addons/from_zero_to_godot/TestRunner/Runners/TestRunnerFuncao.gd",
	TestConfigResource.TYPE_FUNCTION_GROUP: "res://addons/from_zero_to_godot/TestRunner/Runners/TestRunnerFuncao.gd",
	TestConfigResource.TYPE_CLASS: "res://addons/from_zero_to_godot/TestRunner/Runners/TestRunnerClasse.gd",
	TestConfigResource.TYPE_CLASS_CUSTOM: "res://addons/from_zero_to_godot/TestRunner/Runners/TestRunnerClasseCustom.gd",
	TestConfigResource.TYPE_SCENE: "res://addons/from_zero_to_godot/TestRunner/Runners/TestRunnerCena.gd"
}

static func create_runner(test_type: String):
	var normalized_type = TestConfigKeys.normalize_value(TestConfigKeys.TYPE, test_type)
	var runner_path = RUNNER_BY_TYPE.get(normalized_type, "")
	if runner_path.is_empty() or not ResourceLoader.exists(runner_path):
		return null

	var runner_script = load(runner_path)
	if not runner_script:
		return null

	return runner_script.new()
