# Validação de CNPJ Alfanumérico em C

Implementação em C para validação e cálculo dos dígitos verificadores (DV) de CNPJs alfanuméricos.

## Funcionalidades

- Validação de CNPJ alfanumérico completo (12 caracteres alfanuméricos + 2 dígitos verificadores)
- Cálculo dos dígitos verificadores para uma base de CNPJ alfanumérico (12 caracteres)
- Suporte a CNPJs com ou sem máscara

## Como Usar

Inclua os arquivos fonte no seu projeto e utilize as funções:

```c
#include "cnpj.h"

int valido = cnpj_alfanumerico_is_valid("12ABC34501DE35");
char dv[3];
cnpj_alfanumerico_calcula_dv("12ABC34501DE", dv);
```

## Regras de Validação

- 14 caracteres (12 base + 2 DV)
- Apenas letras maiúsculas (A-Z) e números (0-9) na base
- DVs calculados conforme algoritmo do projeto

