# Validador e Gerador de CNPJ Alfanumérico em JavaScript

Esta implementação fornece uma classe para validação e cálculo de dígitos verificadores de CNPJs alfanuméricos.

## Funcionalidades

- Validação de CNPJs alfanuméricos com e sem máscara
- Cálculo do dígito verificador para CNPJs alfanuméricos
- Suporte a CNPJs com caracteres alfanuméricos (letras maiúsculas e números)
- Validação de formato e regras de negócio

## Classe CNPJ

A classe `CNPJ` contém métodos estáticos para:

- **isValid(cnpj)**: Verifica se um CNPJ é válido, considerando formato e dígitos verificadores
- **calculaDV(cnpj)**: Calcula os dígitos verificadores de um CNPJ (sem os DV)
- **removeMascaraCNPJ(cnpj)**: Remove caracteres de formatação (`.`, `/`, `-`)

## Exemplos de Uso

```javascript
// Validação de CNPJ
const cnpjValido = CNPJ.isValid("12.ABC.345/01DE-35");  // true
const cnpjInvalido = CNPJ.isValid("12.ABC.345/01DE-36");  // false

// Cálculo de dígitos verificadores
const dv = CNPJ.calculaDV("12ABC34501DE");  // "35"
```

## Regras de Validação

- CNPJs devem conter 14 caracteres (12 caracteres base + 2 dígitos verificadores)
- São aceitos apenas dígitos e letras maiúsculas (A-Z)
- Os caracteres `.`, `/` e `-` são permitidos como formatação
- CNPJs zerados ("00000000000000") são considerados inválidos
- Os dígitos verificadores devem corresponder ao cálculo definido pela regra de negócio

## Formato Suportado

- Sem máscara: `XXXXXXXXXXXX` + DV
- Com máscara: `XX.XXX.XXX/XXXX-XX` (onde `X` pode ser um dígito ou letra maiúscula)
