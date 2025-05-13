import Foundation

func printUsage() {
    print("Uso:")
    print("  swift main.swift -v <CNPJ>    - Validar um CNPJ completo")
    print("  swift main.swift -dv <CNPJ>   - Calcular os dígitos verificadores de um CNPJ")
    print("")
    print("Exemplos:")
    print("  swift main.swift -v 12ABC34501DE35")
    print("  swift main.swift -dv 12ABC34501DE")
}

func processCNPJ() {
    let arguments = CommandLine.arguments
    
    if arguments.count < 3 {
        printUsage()
        exit(1)
    }
    
    let operation = arguments[1].lowercased()
    let cnpj = arguments[2]
    
    switch operation {
    case "-v":
        let isValid = CNPJ.isValid(cnpj)
        print("CNPJ \(cnpj) é \(isValid ? "válido" : "inválido")")
        
    case "-dv":
        do {
            let dv = try CNPJ.calculateDV(cnpj)
            print("Dígitos verificadores para \(cnpj): \(dv)")
            print("CNPJ completo: \(cnpj)\(dv)")
        } catch {
            print("Erro ao calcular DV: \(error)")
        }
        
    default:
        print("Operação não reconhecida: \(operation)")
        printUsage()
        exit(1)
    }
}

processCNPJ()
