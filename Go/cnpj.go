package cnpj

import (
	"errors"
	"regexp"
	"strings"
)

const (
	tamanhoCNPJSemDV = 12
)

var (
	regexCNPJ                = regexp.MustCompile(`^([A-Z\d]){12}(\d){2}$`)
	regexCNPJSemDV           = regexp.MustCompile(`^([A-Z\d]){12}$`)
	regexCaracteresMascara   = regexp.MustCompile(`[./-]`)
	regexCaracteresPermitidos = regexp.MustCompile(`^[A-Z\d./-]*$`)
	pesosDV                  = []int{6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2}
	cnpjZerado               = "00000000000000"
)

// IsValid verifica se um CNPJ alfanumérico é válido
func IsValid(cnpj string) bool {
	if !regexCaracteresPermitidos.MatchString(cnpj) {
		return false
	}

	cnpjSemMascara := removeMascaraCNPJ(strings.ToUpper(cnpj))
	if regexCNPJ.MatchString(cnpjSemMascara) && cnpjSemMascara != cnpjZerado {
		dvInformado := cnpjSemMascara[tamanhoCNPJSemDV:]
		dvCalculado, err := CalculaDV(cnpjSemMascara[:tamanhoCNPJSemDV])
		if err == nil {
			return dvInformado == dvCalculado
		}
	}
	
	return false
}

// CalculaDV calcula os dígitos verificadores de um CNPJ alfanumérico
func CalculaDV(cnpj string) (string, error) {
	if !regexCaracteresPermitidos.MatchString(cnpj) {
		return "", errors.New("CNPJ contém caracteres não permitidos")
	}

	cnpjSemMascara := removeMascaraCNPJ(strings.ToUpper(cnpj))
	if regexCNPJSemDV.MatchString(cnpjSemMascara) && cnpjSemMascara != cnpjZerado[:tamanhoCNPJSemDV] {
		dv1 := calculaDigito(cnpjSemMascara)
		dv2 := calculaDigito(cnpjSemMascara + dv1)
		return dv1 + dv2, nil
	}

	return "", errors.New("não é possível calcular o DV pois o CNPJ fornecido é inválido")
}

func calculaDigito(cnpj string) string {
	soma := 0
	for i := 0; i < len(cnpj); i++ {
		valorCaracter := int(cnpj[i]) - int('0')
		soma += valorCaracter * pesosDV[i+pesosDV[len(pesosDV)]-len(cnpj)-1]
	}

	resto := soma % 11
	var dv int
	if resto < 2 {
		dv = 0
	} else {
		dv = 11 - resto
	}

	return string(rune(dv + '0'))
}

func removeMascaraCNPJ(cnpj string) string {
	return regexCaracteresMascara.ReplaceAllString(cnpj, "")
}
