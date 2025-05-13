package main

import (
	"flag"
	"fmt"
	"os"
	"strings"

	"github.com/edsonmoretti/cnpj-alfanumerico/go/cnpj"
)

func main() {
	// Definir flags de linha de comando
	validarFlag := flag.Bool("v", false, "Validar um CNPJ completo")
	calcularDVFlag := flag.Bool("dv", false, "Calcular o DV de um CNPJ base")
	
	// Analisar os argumentos
	flag.Parse()
	
	// Verificar se pelo menos uma operação foi selecionada
	if !*validarFlag && !*calcularDVFlag {
		fmt.Println("Por favor, especifique uma operação: -v para validar ou -dv para calcular DV")
		flag.Usage()
		os.Exit(1)
	}
	
	// Obter os CNPJs dos argumentos restantes
	args := flag.Args()
	if len(args) == 0 {
		fmt.Println("Por favor, forneça pelo menos um CNPJ como argumento")
		flag.Usage()
		os.Exit(1)
	}
	
	// Processar cada CNPJ fornecido
	for i, cnpjInput := range args {
		// Converter para maiúsculas para garantir a compatibilidade
		cnpjInput = strings.ToUpper(cnpjInput)
		
		if *validarFlag {
			// Modo de validação
			if cnpj.IsValid(cnpjInput) {
				fmt.Printf("[%d] CNPJ: [%s] ✓ Válido\n", i+1, cnpjInput)
			} else {
				fmt.Printf("[%d] CNPJ: [%s] ✗ Inválido\n", i+1, cnpjInput)
			}
		} else if *calcularDVFlag {
			// Modo de cálculo de DV
			dv, err := cnpj.CalculaDV(cnpjInput)
			if err != nil {
				fmt.Printf("[%d] Erro ao calcular DV para CNPJ [%s]: %v\n", i+1, cnpjInput, err)
			} else {
				fmt.Printf("[%d] CNPJ: [%s] DV: [%s]\n", i+1, cnpjInput, dv)
				fmt.Printf("    CNPJ Completo: %s%s\n", cnpjInput, dv)
			}
		}
	}
}
