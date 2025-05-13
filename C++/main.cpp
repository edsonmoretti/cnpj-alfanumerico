#include "cnpj.h"
#include <iostream>
#include <string>
#include <vector>

void print_usage() {
    std::cout << "Uso:\n";
    std::cout << "  Para validar: ./cnpj -v CNPJ1 [CNPJ2 CNPJ3 ...]\n";
    std::cout << "  Para calcular DV: ./cnpj -dv CNPJ1 [CNPJ2 CNPJ3 ...]\n";
    std::cout << "\nExemplos:\n";
    std::cout << "  ./cnpj -v 12ABC34501DE35\n";
    std::cout << "  ./cnpj -dv 12ABC34501DE\n";
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        std::cerr << "Erro: Argumentos insuficientes\n";
        print_usage();
        return 1;
    }
    
    // Verifica a operação solicitada
    std::string operacao = argv[1];
    
    if (operacao == "-v") {
        // Modo de validação
        for (int i = 2; i < argc; i++) {
            std::string cnpjStr = argv[i];
            
            if (CNPJ::isValid(cnpjStr)) {
                std::cout << "[" << (i - 1) << "] CNPJ: [" << cnpjStr << "] ✓ Válido\n";
            } else {
                std::cout << "[" << (i - 1) << "] CNPJ: [" << cnpjStr << "] ✗ Inválido\n";
            }
        }
    } else if (operacao == "-dv") {
        // Modo de cálculo de DV
        for (int i = 2; i < argc; i++) {
            std::string cnpjStr = argv[i];
            
            auto dv = CNPJ::calculaDV(cnpjStr);
            if (dv) {
                std::cout << "[" << (i - 1) << "] CNPJ: [" << cnpjStr << "] DV: [" << *dv << "]\n";
                std::cout << "    CNPJ Completo: " << CNPJ::removeMascaraCNPJ(cnpjStr) << *dv << "\n";
            } else {
                std::cout << "[" << (i - 1) << "] Erro ao calcular DV para CNPJ [" << cnpjStr << "]\n";
            }
        }
    } else {
        std::cerr << "Erro: Operação desconhecida '" << operacao << "'\n";
        print_usage();
        return 1;
    }
    
    return 0;
}
