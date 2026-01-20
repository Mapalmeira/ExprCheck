<div align="center">

# Validador e Avaliador Léxico-Sintático de Expressões Matemáticas

![Haskell](https://img.shields.io/badge/Language-Haskell-5e5086?style=for-the-badge&logo=haskell&logoColor=white)
![Paradigm](https://img.shields.io/badge/Paradigm-Functional-orange?style=for-the-badge)
![UFCG](https://img.shields.io/badge/Institution-UFCG-009639?style=for-the-badge)

<p align="center">
  <b>Projeto desenvolvido para a disciplina de Paradigmas de Linguagens de Programação.</b>
</p>
<p align="center">
  <a href="docs/readme_us.md">Read in English</a>
</p>

</div>

---

## 1. Visão Geral

Este projeto implementa um analisador capaz de **validar e avaliar expressões matemáticas** sob as perspectivas léxica e sintática. Desenvolvido estritamente sob o paradigma funcional em **Haskell**, o sistema verifica se uma cadeia de entrada está em conformidade com uma **Gramática Livre de Contexto (GLC)** previamente definida.

O analisador oferece suporte às principais operações aritméticas, números reais e controle de precedência por meio de parênteses, garantindo a correta interpretação da ordem das operações matemáticas através da construção de uma **Árvore Sintática Abstrata (AST)**.

---

## 2. Especificação Técnica

O processo de validação ocorre em duas etapas sequenciais e bem definidas:

### 2.1. Análise Léxica (Scanning)

A entrada é processada como uma lista de caracteres, na qual são identificados e validados os *tokens* primitivos. O analisador ignora espaços em branco e rejeita quaisquer caracteres que não pertençam ao alfabeto válido da linguagem.

**Tokens reconhecidos:**

- **Literais:**  
  `TokInt` (inteiros), `TokReal` (números de ponto flutuante)

- **Operadores:**  
  `TokPlus` (+), `TokMinus` (-), `TokStar` (*), `TokSlash` (/), `TokCaret` (^)

- **Delimitadores:**  
  `TokLParen` (`(`) e `TokRParen` (`)`)

---

### 2.2. Análise Sintática (Parsing)

O sistema utiliza um **Analisador Descendente Recursivo** (*Recursive Descent Parser*) para validar a estrutura gramatical das expressões. Essa abordagem permite tratar a precedência de operadores diretamente na hierarquia das chamadas de função, evitando ambiguidades e eliminando a necessidade de recursão à esquerda direta.

**Gramática Livre de Contexto (BNF):**

```text
Exp     -> Sum EOF
Sum     -> Mul Sum'
Sum'    -> + Mul Sum' | - Mul Sum' | ε
Mul     -> Pow Mul'
Mul'    -> * Pow Mul' | / Pow Mul' | ε
Pow     -> Unary Pow'
Pow'    -> ^ Pow | ε
Unary   -> + Primary | - Primary | Primary
Primary -> INT | REAL | '(' Sum ')'
```

---

## 3. Matriz de Testes

A tabela a seguir apresenta alguns dos casos de teste utilizados para validar a robustez do analisador. Note que o parser suporta operadores unários repetidos (como ++ ou --), interpretando-os corretamente de acordo com a semântica matemática.

| Expressão de Entrada | Resultado  | Justificativa Técnica                                  |
| -------------------- | ---------- | ------------------------------------------------------ |
| `1 + 2 * 3`          | Aceito     | Respeita a precedência: `*` é avaliado antes de `+`.   |
| `(3 + 2) * 7`        | Aceito     | Uso correto de parênteses para agrupamento.            |
| `12.3 + 4.56`        | Aceito     | Reconhecimento correto de literais reais.              |
| `5 ^ -2`             | Aceito     | Operador unário aplicado corretamente ao expoente.     |
| `5 ++ 5`             | **Aceito** | Interpretado como soma de valor positivo (`5 + (+5)`). |
| `(5 * 2`             | Rejeitado  | Erro sintático: parênteses não balanceados.            |
| `1 + @`              | Rejeitado  | Erro léxico: símbolo fora do alfabeto válido.          |

---

## 4. Instruções de Execução

Este projeto utiliza o ecossistema **Cabal** para gerenciamento de dependências, compilação e execução de testes.

### Pré-requisitos

Antes de começar, certifique-se de ter o ambiente Haskell configurado:

- **[GHCup](https://www.haskell.org/ghcup/):** Instalador recomendado para o compilador GHC e a ferramenta Cabal.
- **Git:** Para clonar o repositório.

### Instalação

1. Abra o terminal e clone o repositório:

```bash
git clone https://github.com/Mapalmeira/ExprCheck.git ExprCheck/
```

2. Acesse o diretório do projeto:

```bash
cd ExprCheck
```

### Utilização

O projeto oferece dois modos de execução:

**1. Modo Interativo (CLI)**
Para validar expressões manualmente através do menu interativo:

```bash
cabal run
```

**2.Modo de testes**
Para realizar os testes presentes no arquivo

```bash
cabal test
```
  
---

## 5. Autores

- [Andrey Kaua Aragao Feitosa](https://github.com/Andrey-Kaua)
- [Erik Alves Almeida](https://github.com/ErikAlvesAlmeida)
- [Isadora Beatriz Lucena de Medeiros](https://github.com/isadoralucena)
- [João Henrique Silva Lima](https://github.com/limajoaohs)
- [Matheus Palmeira Leite Rocha](https://github.com/Mapalmeira)
