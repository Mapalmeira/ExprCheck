<div align="center">

# Lexical-Syntactic Validator and Evaluator of Mathematical Expressions

<p align="center">
<b>Project developed for the Programming Language Paradigms course.</b>
</p>
<p align="center">
<a href="../README.md">Leia em Português</a>
</p>

</div>

---

## 1. Overview

This project implements a parser capable of **validating and evaluating mathematical expressions** from both lexical and syntactic perspectives. Developed strictly under the functional paradigm in **Haskell**, the system checks if an input string conforms to a previously defined **Context-Free Grammar (CFG)**.

The parser supports major arithmetic operations, real numbers, and precedence control via parentheses, ensuring the correct interpretation of the order of operations through the construction of an **Abstract Syntax Tree (AST)**.

---

## 2. Technical Specification

The validation process occurs in two sequential and well-defined stages:

### 2.1. Lexical Analysis (Scanning)

The input is processed as a list of characters, where primitive *tokens* are identified and validated. The parser ignores whitespace and rejects any characters that do not belong to the language's valid alphabet.

**Recognized Tokens:**

* **Literals:** `TokInt` (integers), `TokReal` (floating-point numbers)
* **Operators:** `TokPlus` (+), `TokMinus` (-), `TokStar` (*), `TokSlash` (/), `TokCaret` (^)
* **Delimiters:** `TokLParen` (`(`) and `TokRParen` (`)`)

---

### 2.2. Syntactic Analysis (Parsing)

The system uses a **Recursive Descent Parser** to validate the grammatical structure of expressions. This approach allows handling operator precedence directly within the function call hierarchy, avoiding ambiguities and eliminating the need for direct left recursion.

**Context-Free Grammar (BNF):**

```text
Exp     -> Sum EOF
Sum     -> Mul Sum'
Sum'    -> + Mul Sum' | - Mul Sum' | ε
Mul     -> Pow Mul'
Mul'    -> * Pow Mul' | / Pow Mul' | ε
Pow     -> Unary Pow'
Pow'    -> ^ Pow | ε
Unary   -> + Primary | - Primary | Primary
Primary -> int | real | '(' Sum ')'

```

---

## 3. Test Matrix

The following table presents some of the test cases used to validate the parser's robustness. Note that the parser supports repeated unary operators (such as `++` or `--`), interpreting them correctly according to mathematical semantics.

| Input Expression | Result | Technical Justification |
| --- | --- | --- |
| `1 + 2 * 3` | Accepted | Respects precedence: `*` is evaluated before `+`. |
| `(3 + 2) * 7` | Accepted | Correct use of parentheses for grouping. |
| `12.3 + 4.56` | Accepted | Correct recognition of real literals. |
| `5 ^ -2` | Accepted | Unary operator correctly applied to the exponent. |
| `5 ++ 5` | **Accepted** | Interpreted as addition of a positive value (`5 + (+5)`). |
| `(5 * 2` | Rejected | Syntax error: unbalanced parentheses. |
| `1 + @` | Rejected | Lexical error: symbol outside the valid alphabet. |

---

## 4. Execution Instructions

This project uses **Cabal** for dependency management and building.

### Prerequisites

* **GHC & Cabal:** We recommend installation via [GHCup](https://www.haskell.org/ghcup/).

### Step by Step

1. **Clone the repository:**
```bash
git clone https://github.com/Mapalmeira/ExprCheck.git
cd ExprCheck

```


2. **Run the interactive CLI:**
To manually validate expressions via the menu:
```bash
cabal run

```


3. **Run automated tests:**
To run the lexical and syntactic test suite:
```bash
cabal test

```



---

## 5. Authors

* [Andrey Kaua Aragao Feitosa](https://github.com/Andrey-Kaua)
* [Erik Alves Almeida](https://github.com/ErikAlvesAlmeida)
* [Isadora Beatriz Lucena de Medeiros](https://github.com/isadoralucena)
* [João Henrique Silva Lima](https://github.com/limajoaohs)
* [Matheus Palmeira Leite Rocha](https://github.com/Mapalmeira)

<div align="center">
<sub>UFCG - 2025.2</sub>
</div>