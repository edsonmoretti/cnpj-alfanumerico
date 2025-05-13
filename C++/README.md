# Validação de CNPJ Alfanumérico em C++

Implementação em C++ para validação e cálculo dos dígitos verificadores de CNPJs alfanuméricos.

## Funcionalidades

- Validação de CNPJ alfanumérico completo
- Cálculo dos dígitos verificadores para base de CNPJ
- Suporte a CNPJs com ou sem máscara

## Exemplo de Uso

```cpp
#include "CNPJ.hpp"

bool valido = CNPJ::isValid("12ABC34501DE35");
std::string dv = CNPJ::calculaDV("12ABC34501DE");
```

## Observações

- Siga o algoritmo descrito na raiz do projeto para garantir compatibilidade.
