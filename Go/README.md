# Validação de CNPJ Alfanumérico em Go

Este diretório contém a implementação em Go para validação e cálculo de dígitos verificadores (DV) de CNPJs alfanuméricos.

## Funcionalidades

- Validação de CNPJ alfanumérico completo (12 caracteres alfanuméricos + 2 dígitos verificadores)
- Cálculo de dígitos verificadores para uma base de CNPJ alfanumérico (12 caracteres)
- Suporte para CNPJs com ou sem máscara de formatação

## Como Usar

### Validar um CNPJ

Para verificar se um CNPJ alfanumérico é válido:

```go
import "github.com/edsonmoretti/cnpj-alfanumerico/go/cnpj"

func main() {
    cnpjCompleto := "12ABC34501DE35"
    
    if cnpj.IsValid(cnpjCompleto) {
        fmt.Println("CNPJ válido!")
    } else {
        fmt.Println("CNPJ inválido!")
    }
}
```

### Calcular o Dígito Verificador

Para calcular os dígitos verificadores de uma base de CNPJ:

```go
import "github.com/edsonmoretti/cnpj-alfanumerico/go/cnpj"

func main() {
    baseCnpj := "12ABC34501DE"
    
    dv, err := cnpj.CalculaDV(baseCnpj)
    if err != nil {
        fmt.Printf("Erro: %v\n", err)
        return
    }
    
    fmt.Printf("Dígito Verificador: %s\n", dv)
    fmt.Printf("CNPJ Completo: %s%s\n", baseCnpj, dv)
}
```

## Exemplo de Uso

Execute o programa principal incluído neste diretório:

```bash
# Validar um CNPJ
go run main.go -v 12ABC34501DE35

# Calcular os dígitos verificadores
go run main.go -dv 12ABC34501DE
```

## Regras de Validação

- O CNPJ deve ter 14 caracteres (12 alfanuméricos para a base + 2 dígitos verificadores numéricos)
- Apenas letras maiúsculas (A-Z) e números (0-9) são permitidos na base
- O CNPJ não pode ser composto apenas por zeros
- Os dígitos verificadores são calculados de acordo com o algoritmo específico para CNPJs alfanuméricos
