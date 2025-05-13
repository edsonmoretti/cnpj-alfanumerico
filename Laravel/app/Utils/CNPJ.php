<?php

namespace App\Utils;

class CNPJ
{
    public static function isValid($cnpj)
    {
        $cnpj = self::removeMascaraCNPJ(strtoupper($cnpj));
        if (!preg_match('/^([A-Z\d]{12})(\d{2})$/', $cnpj)) {
            return false;
        }
        if ($cnpj === str_repeat('0', 14)) {
            return false;
        }
        $dvInformado = substr($cnpj, 12, 2);
        $dvCalculado = self::calculaDV(substr($cnpj, 0, 12));
        return $dvInformado === $dvCalculado;
    }

    public static function calculaDV($base)
    {
        $base = self::removeMascaraCNPJ(strtoupper($base));
        if (!preg_match('/^[A-Z\d]{12}$/', $base)) {
            return '';
        }
        if ($base === str_repeat('0', 12)) {
            return '';
        }
        $dv1 = self::calculaDigito($base, [5,4,3,2,9,8,7,6,5,4,3,2]);
        $dv2 = self::calculaDigito($base . $dv1, [6,5,4,3,2,9,8,7,6,5,4,3,2]);
        return $dv1 . $dv2;
    }

    private static function calculaDigito($base, $pesos)
    {
        $soma = 0;
        for ($i = 0; $i < count($pesos); $i++) {
            $caractere = $base[$i];
            if (ctype_digit($caractere)) {
                $valor = intval($caractere);
            } else {
                $valor = ord($caractere) - 48 - 7;
            }
            $soma += $valor * $pesos[$i];
        }
        $resto = $soma % 11;
        return ($resto < 2) ? '0' : strval(11 - $resto);
    }

    public static function removeMascaraCNPJ($cnpj)
    {
        return preg_replace('/[.\-\/]/', '', $cnpj);
    }
}
