#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "cnpj.h"

void print_usage() {
    printf("Uso:\n");
    printf("  Para validar: cnpj -v CNPJ1 [CNPJ2 CNPJ3 ...]\n");
    printf("  Para calcular DV: cnpj -dv CNPJ1 [CNPJ2 CNPJ3 ...]\n");
    printf("\nExemplos:\n");
    printf("  cnpj -v 12ABC34501DE35\n");
    printf("  cnpj -dv 12ABC34501DE\n");
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Erro: Argumentos insuficientes\n");
        print_usage();
        return 1;
    }
    
    // Verifica a operação solicitada
    char *operacao = argv[1];
    
    if (strcmp(operacao, "-v") == 0) {
        // Modo de validação
        for (int i = 2; i < argc; i++) {
            char *cnpj = argv[i];
            if (is_valid(cnpj)) {
                printf("[%d] CNPJ: [%s] ✓ Válido\n", i - 1, cnpj);
            } else {
                printf("[%d] CNPJ: [%s] ✗ Inválido\n", i - 1, cnpj);
            }
        }
    } else if (strcmp(operacao, "-dv") == 0) {
        // Modo de cálculo de DV
        for (int i = 2; i < argc; i++) {
            char *cnpj = argv[i];
            char dv[3];
            
            if (calcula_dv(cnpj, dv) == 0) {
                printf("[%d] CNPJ: [%s] DV: [%s]\n", i - 1, cnpj, dv);
                
                // Converte para maiúsculas para garantir consistência
                char cnpj_upper[100];
                int j = 0;
                while (cnpj[j]) {
                    cnpj_upper[j] = toupper(cnpj[j]);
                    j++;
                }
                cnpj_upper[j] = '\0';
                
                // Remove a máscara para exibir o CNPJ completo
                char cnpj_sem_mascara[100];
                remove_mascara_cnpj(cnpj_upper, cnpj_sem_mascara, 100);
                printf("    CNPJ Completo: %s%s\n", cnpj_sem_mascara, dv);
            } else {
                printf("[%d] Erro ao calcular DV para CNPJ [%s]\n", i - 1, cnpj);
            }
        }
    } else {
        printf("Erro: Operação desconhecida '%s'\n", operacao);
        print_usage();
        return 1;
    }
    
    return 0;
}
