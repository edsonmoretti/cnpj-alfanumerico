# Validação de CNPJ Alfanumérico em Swift

Este diretório contém uma implementação em Swift para validar e calcular dígitos verificadores de CNPJs alfanuméricos.

## Funcionalidades

- Validação de CNPJ alfanumérico completo (12 caracteres alfanuméricos + 2 dígitos verificadores)
- Cálculo de dígitos verificadores para uma base de CNPJ alfanumérico (12 caracteres)
- Suporte para CNPJs com ou sem máscara de formatação

## Requisitos

- Swift 5.0 ou superior
- macOS, Linux ou qualquer plataforma que suporte Swift

## Como Usar

### Em linha de comando

Clone o repositório e navegue até o diretório Swift:

```bash
cd Swift
```

#### Validar um CNPJ:

```bash
swift main.swift -v 12ABC34501DE35
```

#### Calcular os dígitos verificadores:

```bash
swift main.swift -dv 12ABC34501DE
```

### Em seu próprio código Swift

Copie o arquivo `CNPJ.swift` para o seu projeto e use a classe CNPJ:

```swift
// Validar um CNPJ
let cnpjValido = CNPJ.isValid("12ABC34501DE35")
print("CNPJ é válido? \(cnpjValido)")

// Calcular DV de um CNPJ
do {
    let dv = try CNPJ.calculateDV("12ABC34501DE")
    print("Dígitos verificadores: \(dv)")
} catch {
    print("Erro: \(error)")
}
```

## Regras de Validação

Os CNPJs alfanuméricos seguem as seguintes regras:

1. São formados por 12 caracteres alfanuméricos (base) + 2 dígitos verificadores numéricos
2. Apenas caracteres alfanuméricos são aceitos na base (A-Z e 0-9)
3. Os dígitos verificadores são calculados com base na conversão ASCII dos caracteres:
   - Dígitos (0-9) são convertidos para seus valores numéricos
   - Letras (A-Z) são convertidas para valores ASCII - 48
   
   Exemplo: 'A' (ASCII 65) se torna 17, 'B' (ASCII 66) se torna 18

4. O algoritmo usa pesos específicos para o cálculo dos DVs e segue o mesmo princípio do CNPJ tradicional

## Exemplo Prático

Para o CNPJ base `12ABC34501DE`:

1. Os valores convertidos são: `[1, 2, 17, 18, 19, 3, 4, 5, 0, 1, 20, 21]`
2. O primeiro DV calculado é 3
3. O segundo DV calculado é 5
4. O CNPJ completo com DVs é: `12ABC34501DE35`
