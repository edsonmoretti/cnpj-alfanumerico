# Validação de CNPJ Alfanumérico em Scala

Implementação em Scala para validação e cálculo dos dígitos verificadores (DV) de CNPJs alfanuméricos.

## Funcionalidades

- Validação de CNPJ alfanumérico completo (12 caracteres alfanuméricos + 2 dígitos verificadores)
- Cálculo dos dígitos verificadores para uma base de CNPJ alfanumérico (12 caracteres)
- Suporte a CNPJs com ou sem máscara

## Exemplo de Uso

```scala
val valido = CNPJ.isValid("12ABC34501DE35")
val dv = CNPJ.calculaDV("12ABC34501DE")
```

## Regras de Validação

- O CNPJ deve ter 14 caracteres (12 base + 2 DV)
- Apenas letras maiúsculas (A-Z) e números (0-9) na base
- Os dígitos verificadores são calculados conforme o algoritmo do projeto

