# 📘 **Lista 4 – Listas e Dicionários**

---

## **1️⃣ Gerenciador de Tarefas (Aplicativo de TODO)**
[open_scene](Exercicio1/Exercicio1.tscn) 
[open_test](Lista4/Exercicio1)

### Tarefa:

Complete as classes `OrganizadorDeTarefas` e `Tarefa`:

**Classe OrganizadorDeTarefas:**

| Método | Descrição |
|--------|-----------|
| `adicionar_tarefa(desc: String)` | Instancia `Tarefa` e adiciona a `_tarefas` |
| `concluir_tarefa(indice: int)` | Marca `concluida = true` se índice válido |
| `deletar_tarefa(indice: int)` | Deleta a tarefa se índice válido |
| `get_tarefas(): Array` | Retorna cópia de `_tarefas` |

**Classe Tarefa:**

| Método | Descrição |
|--------|-----------|
| `_init(p_id, p_descricao)` | Constrói a instância da classe Tarefa |
| `marcar_concluida()` | Atribui a propriedade de `concluída` para verdadeiro |

<details><summary>Dica</summary>Use `tarefas.duplicate()` ou itere para criar um novo `Array` antes de retornar.</details>

---
---

## **2️⃣ Inventário**
[open_scene](Exercicio2/Exercicio2.tscn) 
[open_test](Lista4/Exercicio2)

### Tarefa:

A classe `Inventario` já vem com a propriedade `_itens: Dictionary = {}`. 

**Classe Inventario:**

| Método | Descrição |
|--------|-----------|
| `vazio() -> bool` | Retorna cópia de `_itens` |
| `adicionar_item(nome: String, qtd: int)` | Cria instância do `Item` e adiciona em `_itens` |
| `remover_item(nome: String, qtd: int)` | Remove um número `qtd` de `Item`. Caso não tenha mais nenhum item, remove ele de `_itens` |
| `get_itens(): Dictionary` | Retorna cópia de `_itens` |
| `get_item_nome(id: int) -> String` | Retorna nome correspondente ao item com o índice `id`, caso não exista, retorna uma String vazia |
| `get_item_descricao(id: int) -> String` | Retorna a descrição correspondente ao item com o índice `id`, caso não exista, retorna uma String vazia |
| `get_item_quantidade(id: int) -> int` | Retorna a quantidade do item com o índice `id`, caso o item não exista, retorna -1 |
| `get_item_nome_com_quantidade(id: int) -> String` | Retorna nome correspondente ao item com o índice `id`, junto com a quantidade desse item, caso não exista, retorna uma String vazia |

**Classe Item:**

| Método | Descrição |
|--------|-----------|
| `_init(p_id, p_descricao, p_nome, p_descricao, p_textura)` | Constrói a instância da classe Item |
| `to_dict()` | Retorna a instância atual em formato de um dicionário |

<details><summary>Dica</summary>As chaves do dicionário do `to_dict()` do `Item` precisam ter os mesmos nomes das propriedades do mesmo.</details>
---
