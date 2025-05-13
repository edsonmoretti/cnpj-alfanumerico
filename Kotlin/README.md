# Validação de CNPJ Alfanumérico em Kotlin

Implementação em Kotlin para validação e cálculo dos dígitos verificadores de CNPJs alfanuméricos.

## Funcionalidades

- Validação de CNPJ alfanumérico completo
- Cálculo dos dígitos verificadores para base de CNPJ

## Exemplo de Uso

```kotlin
val valido = CNPJ.isValid("12ABC34501DE35")
val dv = CNPJ.calculaDV("12ABC34501DE")
```

## Observações

- Siga o algoritmo descrito na raiz do projeto para garantir compatibilidade.
