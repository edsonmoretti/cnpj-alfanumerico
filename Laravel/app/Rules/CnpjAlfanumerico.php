<?php

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
