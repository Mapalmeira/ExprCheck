<div align="center">

# Lexical and Syntactic Validator & Evaluator for Mathematical Expressions

![Haskell](https://img.shields.io/badge/Language-Haskell-5e5086?style=for-the-badge&logo=haskell&logoColor=white)
![Paradigm](https://img.shields.io/badge/Paradigm-Functional-orange?style=for-the-badge)
![UFCG](https://img.shields.io/badge/Institution-UFCG-009639?style=for-the-badge)

<p align="center">
  <b>Project developed for the Programming Languages Paradigms course.</b>
</p>

</div>

---

## 1. Overview

This project implements an analyzer capable of **validating and evaluating mathematical expressions** from both lexical and syntactic perspectives. Developed strictly under the **functional paradigm** using **Haskell**, the system verifies whether an input string conforms to a previously defined **Context-Free Grammar (CFG)**.

The analyzer supports the main arithmetic operations, real numbers, and precedence control through parentheses, ensuring correct interpretation of operation order by constructing an **Abstract Syntax Tree (AST)**.

---

## 2. Technical Specification

The validation process is divided into two well-defined sequential stages:

### 2.1. Lexical Analysis (Scanning)

The input is processed as a list of characters, from which primitive *tokens* are identified and validated. The analyzer ignores whitespace and rejects any character that does not belong to the valid language alphabet.

**Recognized tokens:**

- **Literals:**  
  `TokInt` (integers), `TokReal` (floating-point numbers)

- **Operators:**  
  `TokPlus` (+), `TokMinus` (-), `TokStar` (*), `TokSlash` (/), `TokCaret` (^)

- **Delimiters:**  
  `TokLParen` (`(`) and `TokRParen` (`)`)

---

### 2.2. Syntactic Analysis (Parsing)

The system uses a **Recursive Descent Parser** to validate the grammatical structure of expressions. This approach allows operator precedence to be handled directly through the hierarchy of function calls, avoiding ambiguities and eliminating the need for direct left recursion.

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

The table below presents some of the test cases used to validate the robustness of the analyzer. Note that the parser supports repeated unary operators (such as ++ or --), interpreting them correctly according to mathematical semantics.

| Input Expression | Result       | Technical Justification                                   |
| ---------------- | ------------ | --------------------------------------------------------- |
| `1 + 2 * 3`      | Accepted     | Respects precedence: `*` is evaluated before `+`.         |
| `(3 + 2) * 7`    | Accepted     | Correct use of parentheses for grouping.                  |
| `12.3 + 4.56`    | Accepted     | Correct recognition of real literals.                     |
| `5 ^ -2`         | Accepted     | Unary operator correctly applied to the exponent.         |
| `5 ++ 5`         | **Accepted** | Interpreted as addition of a positive value (`5 + (+5)`). |
| `(5 * 2`         | Rejected     | Syntactic error: unbalanced parentheses.                  |
| `1 + @`          | Rejected     | Lexical error: symbol outside the valid alphabet.         |

---
## 4. Execution Instructions

This project uses the Cabal ecosystem for dependency management, compilation, and test execution.

### Prerequisites

Before starting, make sure your Haskell environment is properly configured:

GHCup: Recommended installer for the GHC compiler and Cabal tool.

Git: Required to clone the repository.

### Installation

Clone the repository:
```bash
git clone https://github.com/Mapalmeira/ExprCheck.git
```
Navigate to the project directory:
```
cd ExprCheck
```

### Usage

The project provides two execution modes:

**1. Interactive Mode (CLI)**
To manually validate expressions using the interactive menu:
```bash
cabal run
```

**2. Test Mode**
To run the automated tests included in the project:
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
