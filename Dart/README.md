# Validação de CNPJ Alfanumérico em Dart

Implementação em Dart para validação e cálculo dos dígitos verificadores de CNPJs alfanuméricos.

## Funcionalidades

- Validação de CNPJ alfanumérico completo
- Cálculo dos dígitos verificadores para base de CNPJ

## Exemplo de Uso

```dart
import 'cnpj.dart';

void main() {
  print(CNPJ.isValid("12ABC34501DE35"));
  print(CNPJ.calculaDV("12ABC34501DE"));
}
```

## Observações

- Siga o algoritmo descrito na raiz do projeto para garantir compatibilidade.
