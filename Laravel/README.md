# Validação de CNPJ Alfanumérico no Laravel

Este exemplo mostra como integrar a validação de CNPJ alfanumérico em projetos Laravel, utilizando uma Rule personalizada e aproveitando a lógica já existente em PHP.

## Instalação

1. Copie a classe `CnpjAlfanumerico.php` para `app/Rules/`.
2. Certifique-se de que a classe utilitária `CNPJ.php` (do diretório PHP deste projeto) está disponível em `app/Utils/CNPJ.php` ou ajuste o namespace conforme necessário.

## Exemplo de Rule Personalizada

```php
// app/Rules/CnpjAlfanumerico.php
namespace App\Rules;

use Illuminate\Contracts\Validation\Rule;
use App\Utils\CNPJ;

class CnpjAlfanumerico implements Rule
{
    public function passes($attribute, $value)
    {
        return CNPJ::isValid($value);
    }

    public function message()
    {
        return 'O :attribute informado não é um CNPJ alfanumérico válido.';
    }
}
```

## Exemplo de Uso em Form Request

```php
use App\Rules\CnpjAlfanumerico;

public function rules()
{
    return [
        'cnpj' => ['required', new CnpjAlfanumerico],
    ];
}
```

## Exemplo de Uso em Controller

```php
use App\Rules\CnpjAlfanumerico;

$request->validate([
    'cnpj' => ['required', new CnpjAlfanumerico],
]);
```

## Observações

- O validador aceita CNPJs alfanuméricos com ou sem máscara.
- Para o cálculo dos dígitos verificadores ou outras operações, utilize diretamente a classe `CNPJ` conforme documentação do diretório PHP.

