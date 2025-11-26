<div align="center">

# Lexical-Syntactic Validator and Evaluator for Mathematical Expressions

![Haskell](https://img.shields.io/badge/Language-Haskell-5e5086?style=for-the-badge&logo=haskell&logoColor=white)
![Paradigm](https://img.shields.io/badge/Paradigm-Functional-orange?style=for-the-badge)
![UFCG](https://img.shields.io/badge/Institution-UFCG-009639?style=for-the-badge)

<p align="center">
  <b>Project developed for the Programming Language Paradigms course.</b>
</p>

<p align="center">
  <a href="../README.md">🇧🇷 Ler em Português</a>
</p>

</div>

---

## 📋 Summary

This project consists of the implementation of a parser capable of validating mathematical expressions from lexical and syntactic perspectives. Developed strictly under the functional paradigm using the Haskell language, the system verifies the adherence of an input string to a pre-defined Context-Free Grammar (CFG), supporting fundamental arithmetic operations, real numbers, and precedence via parentheses.

The project also utilized prototyping in Python (via the NLTK library) for prior validation of the absence of ambiguity in the proposed grammar.

---

## 🎯 Objectives

1.  **Functional Paradigm Application:** Utilize resources such as immutability, recursion, pattern matching, and higher-order functions to solve the parsing problem.
2.  **Formal Modeling:** Implement language recognition based on formal production rules.
3.  **Expression Handling:** Ensure correct operator precedence and associativity.

---

## 🛠️ Technical Specification

The validation process is divided into two sequential stages:

### 1. Lexical Analysis (Scanning)
Responsible for verifying the language's alphabet. The input is processed as a list of characters, where primitive tokens are identified and validated.

* **Valid Alphabet:** Digits 0 to 9, decimal point (.), arithmetic operators (+, -, *, /, ^), and parentheses.

Any symbol that does not belong to this set results in immediate rejection of the string.

### 2. Syntactic Analysis (Parsing)
Responsible for structural validation. The system checks if the chain of tokens can be derived from the grammar's start symbol. The implementation considers standard mathematical operator precedence and was designed to avoid ambiguity and direct left recursion.

---

## 🚀 Supported Features

The analyzer correctly processes the following structures:

* **Numeric Types:** Integers (e.g., 10) and Floating Point (e.g., 12.5).
* **Arithmetic Operators:** Addition (+), Subtraction (-), Multiplication (*), Division (/), and Exponentiation (^).
* **Unary Operators:** Handling of negative numbers (e.g., -5).
* **Grouping:** Use of parentheses to alter standard precedence.

---

## 🧪 Test Cases and Validation

Below is the test matrix used to validate the analyzer's robustness, comparing expected inputs with the algorithm's result.

| Input Expression | Result | Technical Justification |
| :--- | :---: | :--- |
| `1 + 2 * 3` | Accepted | Respects operator precedence. |
| `(3 + 2) * 7` | Accepted | Correct use of parentheses for grouping. |
| `12.3 + 4.56` | Accepted | Correct recognition of real literals. |
| `5 ^ -2` | Accepted | Unary operator correctly applied in exponent. |
| `5 ++ 5` | Rejected | Syntactic Error: Absence of operand between operators. |
| `(5 * 2` | Rejected | Syntactic Error: Unbalanced parentheses. |
| `1 + @` | Rejected | Lexical Error: Symbol does not belong to the valid alphabet. |

---

## 💻 Execution Instructions

### Prerequisites

To execute this project, you must have the Haskell environment configured on your machine.

* **GHC (Glasgow Haskell Compiler):** The standard compiler for Haskell. Usually installed via GHCup.

### Step-by-Step

1.  **Clone the repository:**
    Open your terminal and run the command below to download the project:
    ```bash
    git clone [https://github.com/Mapalmeira/ExprCheck.git](https://github.com/Mapalmeira/ExprCheck.git)
    cd ExprCheck
    ```

2.  **Load the interpreter:**
    In the project directory, start the Haskell interactive environment:
    ```bash
    ghci Main.hs
    ```

3.  **Run validation:**
    Inside the GHCi terminal (which will appear as `*Main>`), use the `validar` function passing the expression in quotes:
    ```haskell
    *Main> validar "3 * (4 + 5)"
    -- Expected Output: True
    ```

---

## 📚 Academic Context

This project is part of the assessment for the Programming Language Paradigms course, taught in the Computer Science program at the Federal University of Campina Grande (UFCG).

### Authors

* [Andrey Kaua Aragao Feitosa](https://github.com/Andrey-Kaua)
* [Erik Alves Almeida](https://github.com/ErikAlvesAlmeida)
* [Isadora Beatriz Lucena de Medeiros](https://github.com/isadoralucena)
* [João Henrique Silva Lima](https://github.com/limajoaohs)
* [Matheus Palmeira Leite Rocha](https://github.com/Mapalmeira)

---

<div align="center">
  <sub>UFCG - 2025.2</sub>
</div>
