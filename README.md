<div align="center">

# Validador e Avaliador Léxico-Sintático de Expressões Matemáticas

![Haskell](https://img.shields.io/badge/Language-Haskell-5e5086?style=for-the-badge&logo=haskell&logoColor=white)
![Paradigm](https://img.shields.io/badge/Paradigm-Functional-orange?style=for-the-badge)
![UFCG](https://img.shields.io/badge/Institution-UFCG-009639?style=for-the-badge)

<p align="center">
  <b>Projeto desenvolvido para a disciplina de Paradigmas de Linguagens de Programação.</b>
</p>
<p align="center">
  <a href="docs/readme_us.md">🇺🇸 Read in English</a>
</p>
</div>

---

## 📋 Resumo

Este projeto consiste na implementação de um analisador capaz de validar expressões matemáticas sob as perspectivas léxica e sintática. Desenvolvido estritamente sob o paradigma funcional utilizando a linguagem Haskell, o sistema verifica a aderência de uma cadeia de entrada a uma Gramática Livre de Contexto (GLC) pré-definida, suportando operações aritméticas fundamentais, números reais e precedência por parênteses.

O projeto também utilizou prototipagem em Python (via biblioteca NLTK) para validação prévia da ausência de ambiguidade na gramática proposta.

---

## 🎯 Objetivos

1.  **Aplicação do Paradigma Funcional:** Utilizar recursos como imutabilidade, recursão, pattern matching e funções de alta ordem para resolver o problema de parsing.
2.  **Modelagem Formal:** Implementar o reconhecimento de linguagem baseado em regras de produção formais.
3.  **Tratamento de Expressões:** Garantir a correta precedência de operadores e associatividade.

---

## 🛠️ Especificação Técnica

O processo de validação é dividido em duas etapas sequenciais:

### 1. Análise Léxica (Scanning)
Responsável pela verificação do alfabeto da linguagem. A entrada é processada como uma lista de caracteres, onde são identificados e validados os tokens primitivos. Espaços em branco são ignorados durante o processamento.

* **Alfabeto Válido:** Dígitos de 0 a 9, ponto decimal (.), operadores aritméticos (+, -, *, /, ^) e parênteses.

Qualquer símbolo que não pertença a este conjunto resulta em rejeição imediata da cadeia.

### 2. Análise Sintática (Parsing)
Responsável pela validação estrutural. O sistema verifica se a cadeia de tokens pode ser derivada a partir do símbolo inicial da gramática. A implementação considera a precedência de operadores matemáticos padrão e foi projetada para evitar ambiguidade e recursão à esquerda direta.

---

## 🚀 Funcionalidades Suportadas

O analisador processa corretamente as seguintes estruturas:

* **Tipos Numéricos:** Inteiros (ex: 10) e Ponto Flutuante (ex: 12.5).
* **Operadores Aritméticos:** Soma (+), Subtração (-), Multiplicação (*), Divisão (/) e Potenciação (^).
* **Operadores Unários:** Tratamento de números negativos (ex: -5).
* **Agrupamento:** Uso de parênteses para alterar a precedência padrão.

---

## 🧪 Casos de Teste e Validação

Abaixo apresentamos a matriz de testes utilizada para validar a robustez do analisador, confrontando entradas esperadas com o resultado do algoritmo.

| Expressão de Entrada | Resultado | Justificativa Técnica |
| :--- | :---: | :--- |
| `1 + 2 * 3` | Aceito | Respeita a precedência de operadores. |
| `(3 + 2) * 7` | Aceito | Uso correto de parênteses para agrupamento. |
| `12.3 + 4.56` | Aceito | Reconhecimento correto de literais reais. |
| `5 ^ -2` | Aceito | Operador unário aplicado corretamente em expoente. |
| `5 ++ 5` | Rejeitado | Erro Sintático: Ausência de operando entre operadores. |
| `(5 * 2` | Rejeitado | Erro Sintático: Parênteses não balanceados. |
| `1 + @` | Rejeitado | Erro Léxico: Símbolo não pertence ao alfabeto válido. |

---

## 💻 Instruções de Execução

### Pré-requisitos

Para executar este projeto, é necessário ter o ambiente Haskell configurado na sua máquina.

* **GHC (Glasgow Haskell Compiler):** O compilador padrão para Haskell. Normalmente instalado via GHCup.

### Passo a Passo

1.  **Clonar o repositório:**
    Abra o terminal e execute o comando abaixo para baixar o projeto:
    ```bash
    git clone [https://github.com/Mapalmeira/ExprCheck.git](https://github.com/Mapalmeira/ExprCheck.git)
    cd ExprCheck
    ```

2.  **Carregar o interpretador:**
    No diretório do projeto, inicie o ambiente interativo do Haskell:
    ```bash
    ghci Main.hs
    ```

3.  **Executar a validação:**
    Dentro do terminal do GHCi (que aparecerá como `*Main>`), utilize a função `validar` passando a expressão entre aspas:
    ```haskell
    *Main> validar "3 * (4 + 5)"
    -- Saída Esperada: True
    ```

---

## 📚 Contexto Acadêmico

Este projeto integra a avaliação da disciplina de Paradigmas de Linguagens de Programação, lecionada no curso de Ciência da Computação da Universidade Federal de Campina Grande (UFCG).

### Autores

* [Andrey Kaua Aragao Feitosa](https://github.com/Andrey-Kaua)
* [Erik Alves Almeida](https://github.com/ErikAlvesAlmeida)
* [Isadora Beatriz Lucena de Medeiros](https://github.com/isadoralucena)
* [João Henrique Silva Lima](https://github.com/limajoaohs)
* [Matheus Palmeira Leite Rocha](https://github.com/Mapalmeira)

---

<div align="center">
  <sub>UFCG - 2025.2</sub>
</div>
