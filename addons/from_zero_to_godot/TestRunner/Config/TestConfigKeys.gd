@tool
extends RefCounted
class_name TestConfigKeys

const TYPE := "type"
const FUNCTION := "function"
const FUNCTIONS := "functions"
const CLASS := "class"
const SCENE_PATH := "scene_path"
const TEST_FILE := "test_file"
const CASES := "cases"
const METHODS := "methods"
const TIMEOUT := "timeout"
const COMPARISON := "comparison"
const TOLERANCE := "tolerance"
const NAME := "name"
const INPUT := "input"
const EXPECTED_OUTPUT := "expected_output"
const ACTUAL_OUTPUT := "actual_output"
const METHOD := "method"
const CONSTRUCTOR_PARAMS := "constructor_params"
const SETUP_CALLS := "setup_calls"
const PROPERTIES := "properties"
const VALIDATE := "validate"

const KEY_ALIASES := {
	"tipo": TYPE,
	"funcao": FUNCTION,
	"funcoes": FUNCTIONS,
	"classe": CLASS,
	"caminho_cena": SCENE_PATH,
	"arquivo_testes": TEST_FILE,
	"casos": CASES,
	"metodos": METHODS,
	"comparacao": COMPARISON,
	"tolerancia": TOLERANCE,
	"nome": NAME,
	"entrada": INPUT,
	"saida_esperada": EXPECTED_OUTPUT,
	"saida_obtida": ACTUAL_OUTPUT,
	"metodo": METHOD,
	"construtor_params": CONSTRUCTOR_PARAMS,
	"preparacao": SETUP_CALLS,
	"setup": SETUP_CALLS,
	"setup_calls": SETUP_CALLS,
	"propriedades": PROPERTIES,
	"validar": VALIDATE
}

const TYPE_ALIASES := {
	"funcao": "function",
	"grupo_funcoes": "function_group",
	"classe": "class",
	"classe_custom": "class_custom",
	"cena": "scene"
}

const COMPARISON_ALIASES := {
	"exato": "exact",
	"aproximado": "approximate"
}

static func normalize_key(key: String) -> String:
	return KEY_ALIASES.get(key, key)

static func normalize_value(key: String, value):
	if value is String:
		match key:
			TYPE:
				return TYPE_ALIASES.get(value, value)
			COMPARISON:
				return COMPARISON_ALIASES.get(value, value)
	return value

static func normalize_variant(key: String, value):
	if value is Dictionary:
		return normalize_dictionary(value)
	if value is Array:
		return normalize_array(value)
	return normalize_value(key, value)

static func normalize_dictionary(data: Dictionary) -> Dictionary:
	var normalized := {}
	for raw_key in data.keys():
		var normalized_key = normalize_key(str(raw_key))
		normalized[normalized_key] = normalize_variant(normalized_key, data[raw_key])
	return normalized

static func normalize_array(values: Array) -> Array:
	var normalized: Array = []
	for value in values:
		if value is Dictionary:
			normalized.append(normalize_dictionary(value))
		elif value is Array:
			normalized.append(normalize_array(value))
		else:
			normalized.append(value)
	return normalized
