# CNPJ Alfanumérico — Validação e Cálculo Multiplataforma

> **Validação e cálculo de dígitos verificadores para CNPJs alfanuméricos, com implementações robustas em múltiplas linguagens.**

---

## Aviso sobre Geração dos Validadores

Os validadores presentes neste repositório foram gerados com auxílio de Inteligência Artificial, utilizando os modelos Cloud 3.7 Sonnet e GPT-4.1. As implementações seguem as informações e regras oficiais disponibilizadas pela Receita Federal, conforme detalhado em:  
https://www.gov.br/receitafederal/pt-br/acesso-a-informacao/acoes-e-programas/programas-e-atividades/cnpj-alfanumerico

---

## Visão Geral

Este repositório centraliza implementações para validação e cálculo dos dígitos verificadores (DV) de CNPJs alfanuméricos, um padrão utilizado em sistemas modernos que exige interoperabilidade, segurança e precisão. O projeto cobre as principais linguagens do mercado, promovendo reuso, padronização e facilidade de integração.

## Motivação

A crescente adoção de identificadores alfanuméricos em sistemas fiscais e corporativos demanda algoritmos confiáveis para validação e geração de DVs. Este projeto nasceu da necessidade de:

- **Padronizar** o cálculo do DV para CNPJs alfanuméricos.
- **Facilitar integrações** entre sistemas heterogêneos.
- **Evitar fraudes** e inconsistências cadastrais.
- **Demonstrar boas práticas** de implementação multiplataforma.

## Arquitetura do Projeto

```
./
│
├── C/                            # Implementação em C
├── C#/                           # Implementação em C#
├── C++/                          # Implementação em C++
├── Dart/                         # Implementação em Dart
├── Go/                           # Implementação em Go
├── Java/                         # Implementação em Java
├── JavaScript/                   # Implementação em JavaScript
├── Kotlin/                       # Implementação em Kotlin
├── Laravel/                      # Implementação em Laravel
├── PHP/                          # Implementação em PHP
├── Python/                       # Implementação em Python
├── R/                            # Implementação em R
├── Ruby/                         # Implementação em Ruby
├── Rust/                         # Implementação em Rust
├── Scala/                        # Implementação em Scala
├── Swift/                        # Implementação em Swift
├── TypeScript/                   # Implementação em TypeScript
└── README.md                     # Este arquivo
```

Cada subdiretório contém README e exemplos específicos para a linguagem.

## Algoritmo

1. **Conversão**: Cada caractere alfanumérico é convertido em valor numérico (dígitos: 0-9, letras: ASCII - 48).
2. **Cálculo dos DVs**: Aplicação de pesos específicos, soma ponderada, módulo 11 e regras para obtenção dos dois dígitos verificadores.
3. **Validação**: Verifica se o CNPJ informado está conforme o padrão e os DVs calculados.

## Exemplos

### Validação

```plaintext
Entrada: 12ABC34501DE35
Saída:   Válido (DVs conferem)
```

### Cálculo do DV

```plaintext
Entrada: 12ABC34501DE
Saída:   35  (CNPJ completo: 12ABC34501DE35)
```

## Implementações Disponíveis

- [C](./C/README.md)
- [C#](./C#/README.md)
- [C++](./C++/README.md)
- [Dart](./Dart/README.md)
- [Go](./Go/README.md)
- [Java](./Java/README.md)
- [JavaScript](./JavaScript/README.md)
- [Kotlin](./Kotlin/README.md)
- [Laravel](./Laravel/README.md)
- [PHP](./PHP/README.md)
- [Python](./Python/README.md)
- [R](./R/README.md)
- [Ruby](./Ruby/README.md)
- [Rust](./Rust/README.md)
- [Scala](./Scala/README.md)
- [Swift](./Swift/README.md)
- [TypeScript](./TypeScript/README.md)

Cada implementação segue a mesma lógica de negócio, com adaptações idiomáticas para cada linguagem.

## Licença

MIT — Sinta-se livre para usar, adaptar e contribuir.

---
