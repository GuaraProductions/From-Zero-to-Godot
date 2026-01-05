# Testes Customizados por Código

## Visão Geral

Quando os testes via JSON não são suficientes (por exemplo, para validar objetos complexos retornados por métodos), você pode usar **testes customizados por código**.

## Quando Usar

Use testes customizados quando:
- Métodos retornam instâncias de classes (não apenas tipos primitivos)
- Precisa validar propriedades de objetos retornados
- Precisa fazer validações complexas que JSON não consegue expressar
- Quer testar sequências de operações (adicionar, modificar, verificar estado)

## Como Criar

### 1. Criar `tests_config.json`

No diretório do exercício, crie um arquivo `tests_config.json`:

```json
{
  "tipo": "classe_custom",
  "classe": "NomeDaClasse",
  "arquivo_testes": "res://caminho/para/tests_custom.gd"
}
```

**Importante:** Se `tests_config.json` existir, ele tem prioridade sobre `tests.json`.

### 2. Criar arquivo de testes `tests_custom.gd`

Crie um script que herda de `Node` e implementa `get_casos_teste()`:

```gdscript
extends Node

func get_casos_teste() -> Array[Dictionary]:
	return [
		{
			"nome": "Nome descritivo do teste",
			"classe": "NomeDaClasse",  # Nome da classe a ser testada
			"construtor_params": [],    # Parâmetros para o construtor
			"metodo": "nome_do_metodo", # Método a ser chamado
			"entrada": [arg1, arg2],    # Argumentos do método
			"validar": _funcao_validacao  # Função que valida o resultado
		}
	]
```

### 3. Criar funções de validação

Cada função de validação recebe 2 parâmetros:
- `resultado`: O valor retornado pelo método testado
- `instancia`: A instância da classe (para fazer verificações adicionais)

E deve retornar um Dictionary com:
```gdscript
{
	"sucesso": bool,           # true se passou, false se falhou
	"erro": String,            # Mensagem de erro (vazio se sucesso)
	"saida_esperada": Variant, # (Opcional) O que era esperado
	"saida_obtida": Variant    # (Opcional) O que foi obtido
}
```

## Exemplo Completo

### tests_config.json
```json
{
  "tipo": "classe_custom",
  "classe": "OrganizadorDeTarefas",
  "arquivo_testes": "res://listas/Lista4/Exercicio1/tests_custom.gd"
}
```

### tests_custom.gd
```gdscript
extends Node

func get_casos_teste() -> Array[Dictionary]:
	return [
		{
			"nome": "Adicionar tarefa e verificar retorno",
			"classe": "OrganizadorDeTarefas",
			"construtor_params": [],
			"metodo": "adicionar_tarefa",
			"entrada": ["Fazer compras"],
			"validar": _validar_adicionar_tarefa
		},
		{
			"nome": "Verificar lista de tarefas",
			"classe": "OrganizadorDeTarefas",
			"construtor_params": [],
			"metodo": "get_tarefas",
			"entrada": [],
			"validar": _validar_lista
		}
	]

func _validar_adicionar_tarefa(resultado, _instancia):
	# Valida que retornou uma Tarefa
	if resultado == null:
		return {"sucesso": false, "erro": "Retornou null"}
	
	if not resultado.has("id"):
		return {"sucesso": false, "erro": "Tarefa sem propriedade 'id'"}
	
	if resultado.id != 1:
		return {
			"sucesso": false,
			"erro": "ID incorreto",
			"saida_esperada": 1,
			"saida_obtida": resultado.id
		}
	
	return {"sucesso": true, "erro": ""}

func _validar_lista(_resultado, instancia):
	# Adiciona tarefas e verifica
	instancia.adicionar_tarefa("Tarefa 1")
	instancia.adicionar_tarefa("Tarefa 2")
	
	var tarefas = instancia.get_tarefas()
	
	if tarefas.size() != 2:
		return {
			"sucesso": false,
			"erro": "Número incorreto de tarefas",
			"saida_esperada": "2 tarefas",
			"saida_obtida": "%d tarefas" % tarefas.size()
		}
	
	return {"sucesso": true, "erro": ""}
```

## Vantagens

1. **Flexibilidade total**: Você pode fazer qualquer validação em GDScript
2. **Testes sequenciais**: Pode chamar múltiplos métodos na mesma instância
3. **Mensagens claras**: Controle total sobre as mensagens de erro
4. **Debugging**: Pode colocar breakpoints nas funções de validação
5. **Reutilização**: Funções de validação podem ser reutilizadas entre testes

## Comparação: JSON vs Custom

### JSON (TestRunnerClasse)
```json
{
  "metodo": "calcular",
  "casos": [{
    "entrada": [5, 3],
    "saida_esperada": 8
  }]
}
```
✅ Simples para tipos primitivos  
❌ Não valida objetos complexos  
❌ Limitado a comparações diretas

### Custom (TestRunnerClasseCustom)
```gdscript
{
	"metodo": "criar_usuario",
	"entrada": ["João"],
	"validar": func(resultado, _instancia):
		return {
			"sucesso": resultado.nome == "João" and resultado.id > 0,
			"erro": "" if resultado.nome == "João" else "Nome incorreto"
		}
}
```
✅ Valida objetos complexos  
✅ Múltiplas condições  
✅ Testes sequenciais  
✅ Debugging com breakpoints

## Estrutura de Arquivos

```
Lista4/
  Exercicio1/
    Exercicio1.gd           # Código do aluno
    Exercicio1.tscn
    tests_config.json       # Configuração (prioridade)
    tests.json             # (Ignorado se config existe)
    tests_custom.gd        # Testes por código
```

## Dicas

1. **Prefixe parâmetros não usados com `_`**:
   ```gdscript
   func _validar(resultado, _instancia):  # _instancia não usado
   ```

2. **Use helpers para validações comuns**:
   ```gdscript
   func _validar_propriedades(obj, propriedades: Array):
       for prop in propriedades:
           if not obj.has(prop):
               return {"sucesso": false, "erro": "Falta: " + prop}
       return {"sucesso": true, "erro": ""}
   ```

3. **Retorne informações úteis em caso de erro**:
   ```gdscript
   return {
       "sucesso": false,
       "erro": "Valor incorreto",
       "saida_esperada": "10",
       "saida_obtida": str(resultado)
   }
   ```

4. **Teste múltiplos aspectos em um único caso**:
   ```gdscript
   func _validar_completo(resultado, instancia):
       # Valida retorno
       if not _valida_tipo(resultado): return erro
       # Valida estado da instância
       if not _valida_estado(instancia): return erro
       # Valida efeitos colaterais
       if not _valida_efeitos(): return erro
       return sucesso
   ```
