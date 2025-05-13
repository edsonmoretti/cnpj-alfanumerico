# Validação e Cálculo de CNPJ Alfanumérico em PHP

Este diretório contém a implementação de validação e cálculo de dígitos verificadores (DV) para CNPJs alfanuméricos.

## Como Usar

### 1. Validar um CNPJ

Use o método `CNPJ::isValid` para verificar se um CNPJ é válido.

```php
require_once 'CNPJ.php';

$cnpj = "12ABC34501DE35";
if (CNPJ::isValid($cnpj)) {
    echo "CNPJ válido!";
} else {
    echo "CNPJ inválido!";
}
```

### 2. Calcular o Dígito Verificador

Use o método `CNPJ::calculaDV` para calcular os dígitos verificadores de um CNPJ base.

```php
require_once 'CNPJ.php';

$baseCnpj = "12ABC34501DE";
$dv = CNPJ::calculaDV($baseCnpj);
echo "Dígito Verificador: $dv";
```

## Exemplo de Entrada e Saída

### Entrada:
- Base do CNPJ: `12ABC34501DE`

### Saída:
- Dígito Verificador: `35`

### Entrada:
- CNPJ Completo: `12ABC34501DE35`

### Saída:
- Validação: `CNPJ válido!`

## Requisitos

- PHP 7.4 ou superior.
