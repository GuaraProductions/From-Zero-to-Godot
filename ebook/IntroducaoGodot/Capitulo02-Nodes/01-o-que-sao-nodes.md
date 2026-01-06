# O que são Nodes (Nós)?

Nodes são os **blocos de construção** fundamentais no Godot!

## Conceito de Node

Um **Node** é um objeto que tem:
- Propriedades (características)
- Métodos (ações)
- Sinais (eventos)

### Analogia

Pense nos Nodes como **peças de LEGO**:
- Cada peça tem uma função
- Você conecta as peças
- Cria algo complexo com peças simples

## Hierarquia de Nodes

Os Nodes são organizados em **árvore**:

```
Personagem (Node2D)
├─ Sprite (Sprite2D)
├─ Colisor (CollisionShape2D)
└─ Script (comportamento)
```

### Relacionamentos

- **Pai**: Node acima na hierarquia
- **Filho**: Node abaixo na hierarquia
- **Irmão**: Nodes no mesmo nível

## Tipos Principais de Nodes

### Nodes 2D

- `Node2D`: Base para objetos 2D
- `Sprite2D`: Exibir imagens
- `AnimatedSprite2D`: Animações sprite
- `CollisionShape2D`: Formas de colisão

### Nodes de Controle

- `Control`: Base para UI
- `Button`: Botões clicáveis
- `Label`: Texto na tela
- `TextureRect`: Imagens na UI

### Nodes Especiais

- `Node`: Node base (invisível)
- `Timer`: Temporizador
- `AudioStreamPlayer`: Sons
- `Camera2D`: Câmera do jogo

## Por que usar Nodes?

✅ **Reutilizáveis**: Use o mesmo node várias vezes
✅ **Modulares**: Combine para criar complexidade
✅ **Organizados**: Hierarquia clara e lógica
✅ **Flexíveis**: Adicione ou remova facilmente

> 💡 **Lembre-se**: Tudo no Godot é um Node ou uma Scene!

No próximo arquivo, vamos aprender a criar e manipular Nodes!
