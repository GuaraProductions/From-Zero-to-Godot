@tool
extends RefCounted
class_name TestRunnerBase

## Classe base abstrata para diferentes tipos de TestRunners
## Fornece funcionalidade comum para execução de testes, comparação de resultados e emissão de sinais

signal teste_iniciado(index: int, total: int)
signal teste_concluido(resultado: Dictionary)
signal todos_testes_concluidos(resumo: Dictionary)

var dados_teste: Dictionary = {}
var resultados: Array[Dictionary] = []

## Método virtual - deve ser implementado pelas classes filhas
func executar_testes(script_ou_instancia, arquivo_testes: String) -> void:
	push_error("executar_testes() não implementado na classe filha")

## Lê e parseia o arquivo tests.json
func _carregar_dados_teste(arquivo_testes: String) -> bool:
	if not FileAccess.file_exists(arquivo_testes):
		push_error("Arquivo de testes não encontrado: %s" % arquivo_testes)
		return false
	
	var file = FileAccess.open(arquivo_testes, FileAccess.READ)
	if not file:
		push_error("Erro ao abrir arquivo: %s" % arquivo_testes)
		return false
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		push_error("Erro ao parsear JSON: %s" % json.get_error_message())
		return false
	
	dados_teste = json.data
	return true

## Compara dois valores de acordo com o modo de comparação
func _comparar_saidas(obtido, esperado, modo: String = "exato", tolerancia: float = 0.01) -> bool:
	if modo == "aproximado":
		return _comparar_aproximado(obtido, esperado, tolerancia)
	else:
		return _comparar_exato(obtido, esperado)

func _comparar_exato(obtido, esperado) -> bool:
	if typeof(obtido) != typeof(esperado):
		return false
	
	match typeof(obtido):
		TYPE_DICTIONARY:
			return _comparar_dicts_exato(obtido, esperado)
		TYPE_ARRAY:
			return _comparar_arrays_exato(obtido, esperado)
		_:
			return obtido == esperado

func _comparar_aproximado(obtido, esperado, tolerancia: float) -> bool:
	if typeof(obtido) != typeof(esperado):
		return false
	
	match typeof(obtido):
		TYPE_FLOAT, TYPE_INT:
			return abs(float(obtido) - float(esperado)) < tolerancia
		TYPE_DICTIONARY:
			return _comparar_dicts_aproximado(obtido, esperado, tolerancia)
		TYPE_ARRAY:
			return _comparar_arrays_aproximado(obtido, esperado, tolerancia)
		_:
			return obtido == esperado

func _comparar_dicts_exato(dict1: Dictionary, dict2: Dictionary) -> bool:
	if dict1.size() != dict2.size():
		return false
	
	for key in dict1:
		if not dict2.has(key):
			return false
		if not _comparar_exato(dict1[key], dict2[key]):
			return false
	
	return true

func _comparar_dicts_aproximado(dict1: Dictionary, dict2: Dictionary, tolerancia: float) -> bool:
	if dict1.size() != dict2.size():
		return false
	
	for key in dict1:
		if not dict2.has(key):
			return false
		if not _comparar_aproximado(dict1[key], dict2[key], tolerancia):
			return false
	
	return true

func _comparar_arrays_exato(arr1: Array, arr2: Array) -> bool:
	if arr1.size() != arr2.size():
		return false
	
	for i in range(arr1.size()):
		if not _comparar_exato(arr1[i], arr2[i]):
			return false
	
	return true

func _comparar_arrays_aproximado(arr1: Array, arr2: Array, tolerancia: float) -> bool:
	if arr1.size() != arr2.size():
		return false
	
	for i in range(arr1.size()):
		if not _comparar_aproximado(arr1[i], arr2[i], tolerancia):
			return false
	
	return true

## Gera resumo final dos testes
func _gerar_resumo() -> Dictionary:
	var total = resultados.size()
	var passou = 0
	var tempo_total = 0
	
	for resultado in resultados:
		if resultado.passou:
			passou += 1
		tempo_total += resultado.tempo_ms
	
	var falhou = total - passou
	var percentual = (float(passou) / float(total)) * 100.0 if total > 0 else 0.0
	var tempo_medio = float(tempo_total) / float(total) if total > 0 else 0.0
	
	return {
		"total": total,
		"passou": passou,
		"falhou": falhou,
		"percentual": percentual,
		"tempo_total_ms": tempo_total,
		"tempo_medio_ms": tempo_medio
	}
