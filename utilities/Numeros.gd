extends Node
class_name Numeros

static func formatar(numero: float, max_decimals: int = 14) -> String:
	var format_str := "%." + str(max_decimals) + "f"
	var s := format_str % numero 

	if s.find(".") != -1:
		while s.ends_with("0"): s = s.substr(0, s.length() - 1)

		if s.ends_with("."): s = s.substr(0, s.length() - 1)

	return s

static func formatar_decimais(numero, qts_decimais: int = 2) -> String:
	return str(numero).pad_decimals(qts_decimais)
