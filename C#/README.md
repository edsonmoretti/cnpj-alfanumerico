# Validação de CNPJ Alfanumérico em C#

Esta implementação em C# permite validar e calcular dígitos verificadores (DV) para CNPJs alfanuméricos, seguindo as regras específicas para esse tipo de documento.

## Funcionalidades

- Validação de CNPJ alfanumérico completo (12 caracteres alfanuméricos + 2 dígitos verificadores)
- Cálculo de dígitos verificadores para uma base de CNPJ alfanumérico (12 caracteres)
- Suporte para CNPJs com ou sem máscara de formatação

## Requisitos

- .NET 6.0 ou superior

## Compilação e Execução

Para compilar e executar o projeto:

```bash
cd C#
dotnet build
dotnet run -- -v 12ABC34501DE35
```

## Como Usar

### Via Linha de Comando

O programa pode ser executado de duas maneiras:

#### Para validar um CNPJ:

```bash
dotnet run -- -v 12ABC34501DE35
```

#### Para calcular os dígitos verificadores:

```bash
dotnet run -- -dv 12ABC34501DE
```

### Integrando em seu Código

#### Para validar um CNPJ:

```csharp
using CNPJAlfanumerico;

string cnpjCompleto = "12ABC34501DE35";

if (CNPJ.IsValid(cnpjCompleto))
{
    Console.WriteLine("CNPJ válido!");
}
else
{
    Console.WriteLine("CNPJ inválido!");
}
```

#### Para calcular os dígitos verificadores:

```csharp
using CNPJAlfanumerico;

string baseCnpj = "12ABC34501DE";

try
{
    string dv = CNPJ.CalculaDV(baseCnpj);
    Console.WriteLine($"Dígitos verificadores: {dv}");
    Console.WriteLine($"CNPJ completo: {baseCnpj}{dv}");
}
catch (Exception ex)
{
    Console.WriteLine($"Erro ao calcular os dígitos verificadores: {ex.Message}");
}
```

## Algoritmo de Validação

A validação e o cálculo dos dígitos verificadores do CNPJ alfanumérico seguem estas regras:

1. Cada caractere alfanumérico é convertido para um valor numérico:
   - Dígitos (0-9): valor igual ao dígito
   - Letras (A-Z): valor = código ASCII - 48 - 7
   
2. Para o primeiro dígito verificador (DV1):
   - Aplicar os pesos [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2] aos 12 primeiros caracteres
   - Multiplicar cada valor pelo peso correspondente
   - Somar todos os produtos
   - Calcular o resto da divisão por 11
   - Se o resto for menor que 2, DV1 = 0; caso contrário, DV1 = 11 - resto

3. Para o segundo dígito verificador (DV2):
   - Adicionar o DV1 à sequência (total de 13 caracteres)
   - Aplicar os pesos [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
   - Repetir o processo de cálculo como no DV1

## Exemplo Prático

### Entrada:
Base do CNPJ: `12ABC34501DE`

### Processo:
1. Conversão: `[1, 2, 17, 18, 19, 3, 4, 5, 0, 1, 20, 21]`
2. Cálculo DV1: resultado `3`
3. Cálculo DV2: resultado `5`

### Saída:
- Dígitos Verificadores: `35`
- CNPJ Completo: `12ABC34501DE35`
