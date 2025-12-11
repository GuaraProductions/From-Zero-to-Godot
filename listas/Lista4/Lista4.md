### 📘 **Lista 4 – Listas e Dicionários**

**Objetivo:**  
Nessa lista vamos revisar o que aprendemos sobre listas e dicionários.
---

#### **1️⃣ Gerenciador de Tarefas (Aplicativo de TODO)**  

**Tarefa:**  

- Complete a classe `OrganizadorDeTarefas` e `Tarefa`:
- `OrganizadorDeTarefas`
  - `adicionar_tarefa(desc: String)` → instancia `Tarefa` e adiciona a `_tarefas`
  - `concluir_tarefa(indice: int)` → marca `concluida = true` se índice válido
  - `deletar_tarefa(indice: int)` → deleta a tarefa se índice válido
  - `get_tarefas(): Array` → retorna cópia de `_tarefas`
- `Tarefa`
  - `_init(p_id, p_descricao)` → constroi a instancia da classe Tarefa
  - `marcar_concluida()` → atribui a propriedade de `concluída` para verdadeiro

<details><summary>Dica</summary>Use `tarefas.duplicate()` ou itere para criar um novo `Array` antes de retornar.</details>

---

#### **2️⃣ Inventário**  
A classe `Inventario` já vem com a propriedade `_itens: Dictionary = {}`. Complete:
- `vazio() -> bool` → retorna cópia de `_itens`.   
- `adicionar_item(nome: String, qtd: int)` → cria instância do `Item` e adiciona em `_itens`.
- `remover_item(nome: String, qtd: int)` → remove um número `qtd` de `Item`. Caso não tenha mais nenhum item, remover ele de `_itens`.
- `get_itens(): Dictionary` → retorna cópia de `_itens`.  
- `get_item_nome(id: int) -> String` → retorna nome correspondente ao item com o indice `id`, caso não exista, retorne uma String vazia. 
- `get_item_descricao(id: int) -> String` → retorna a descrição correspondente ao item com o indice `id`, caso não exista, retorne uma String vazia. 
- `get_item_quantidade(id: int) -> int` → retorna a quantidade do item com o indice `id`, caso o item não exista, retorne -1
- `get_item_nome_com_quantidade(id: int) -> String` → retorna nome correspondente ao item com o indice `id`, junto com a quantidade desse item, caso não exista, retorne uma String vazia. 

Complete também a classe `Item`:
  - `_init(p_id, p_descricao, p_nome, p_descricao, p_textura)` → constroi a instancia da classe Item
  - `to_dict()` → retorna a instancia atual e formato de um dicionario

DICA: As chaves do dicionário do `to_dict()` do `Item` precisam ter os mesmos nomes das propriedades do mesmo.
---
