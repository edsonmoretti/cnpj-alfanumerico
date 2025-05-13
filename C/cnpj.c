#include "cnpj.h"
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

#define TAMANHO_CNPJ_SEM_DV 12
#define TAMANHO_CNPJ_COMPLETO 14
#define TAMANHO_BUFFER 20

static const int pesos_dv1[] = {5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
static const int pesos_dv2[] = {6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};

// Converte um caractere alfanumérico para seu valor numérico
static int converter_caractere(char c) {
    // Se for dígito, retorna seu valor numérico
    if (isdigit(c)) {
        return c - '0';
    }
    // Se for letra maiúscula, retorna seu valor convertido (A=17, B=18, etc.)
    else if (isupper(c)) {
        return c - '0' - 7; // 'A' ASCII 65 - '0' ASCII 48 - 7 = 10
    }
    // Caractere inválido
    return -1;
}

// Verifica se um caractere é permitido (letra maiúscula ou dígito)
static bool caractere_permitido(char c) {
    return (isdigit(c) || (isupper(c) && c >= 'A' && c <= 'Z'));
}

// Verifica se uma string contém apenas caracteres permitidos
static bool apenas_caracteres_permitidos(const char* str) {
    while (*str) {
        if (*str != '.' && *str != '/' && *str != '-' && !caractere_permitido(*str)) {
            return false;
        }
        str++;
    }
    return true;
}

// Verifica se um CNPJ contém apenas zeros
static bool apenas_zeros(const char* cnpj) {
    for (int i = 0; i < TAMANHO_CNPJ_COMPLETO && cnpj[i]; i++) {
        if (cnpj[i] != '0') {
            return false;
        }
    }
    return true;
}

// Calcula um dígito verificador com base nos pesos fornecidos
static int calcular_digito(const char* cnpj, const int* pesos, int tamanho) {
    int soma = 0;
    
    for (int i = 0; i < tamanho; i++) {
        int valor = converter_caractere(cnpj[i]);
        if (valor < 0) return -1; // Caractere inválido
        soma += valor * pesos[i];
    }
    
    int resto = soma % 11;
    if (resto < 2) {
        return 0;
    } else {
        return 11 - resto;
    }
}

void remove_mascara_cnpj(const char* cnpj, char* cnpj_sem_mascara, int tamanho) {
    int j = 0;
    for (int i = 0; cnpj[i] && j < tamanho - 1; i++) {
        if (cnpj[i] != '.' && cnpj[i] != '/' && cnpj[i] != '-') {
            cnpj_sem_mascara[j++] = toupper(cnpj[i]);
        }
    }
    cnpj_sem_mascara[j] = '\0';
}

bool is_valid(const char* cnpj) {
    if (!cnpj || !apenas_caracteres_permitidos(cnpj)) {
        return false;
    }
    
    char cnpj_sem_mascara[TAMANHO_BUFFER];
    remove_mascara_cnpj(cnpj, cnpj_sem_mascara, TAMANHO_BUFFER);
    
    // Verifica o tamanho do CNPJ sem máscara
    if (strlen(cnpj_sem_mascara) != TAMANHO_CNPJ_COMPLETO) {
        return false;
    }
    
    // Verifica se o CNPJ não contém apenas zeros
    if (apenas_zeros(cnpj_sem_mascara)) {
        return false;
    }
    
    // Extrai os dígitos verificadores informados
    char dv_informado[3] = {cnpj_sem_mascara[TAMANHO_CNPJ_SEM_DV], 
                           cnpj_sem_mascara[TAMANHO_CNPJ_SEM_DV + 1], '\0'};
    
    // Calcula os dígitos verificadores
    char dv_calculado[3];
    if (calcula_dv(cnpj_sem_mascara, dv_calculado) != 0) {
        return false;
    }
    
    // Compara os dígitos verificadores
    return strcmp(dv_informado, dv_calculado) == 0;
}

int calcula_dv(const char* cnpj, char* dv) {
    if (!cnpj || !dv || !apenas_caracteres_permitidos(cnpj)) {
        return -1;
    }
    
    char cnpj_sem_mascara[TAMANHO_BUFFER];
    remove_mascara_cnpj(cnpj, cnpj_sem_mascara, TAMANHO_BUFFER);
    
    // Verifica o tamanho da base do CNPJ
    size_t tamanho = strlen(cnpj_sem_mascara);
    if (tamanho != TAMANHO_CNPJ_SEM_DV && tamanho != TAMANHO_CNPJ_COMPLETO) {
        return -1;
    }
    
    // Usa apenas os primeiros 12 caracteres
    char cnpj_base[TAMANHO_CNPJ_SEM_DV + 1];
    strncpy(cnpj_base, cnpj_sem_mascara, TAMANHO_CNPJ_SEM_DV);
    cnpj_base[TAMANHO_CNPJ_SEM_DV] = '\0';
    
    // Verifica se o CNPJ não contém apenas zeros
    if (apenas_zeros(cnpj_base)) {
        return -1;
    }
    
    // Calcula o primeiro dígito verificador
    int dv1 = calcular_digito(cnpj_base, pesos_dv1, TAMANHO_CNPJ_SEM_DV);
    if (dv1 < 0) {
        return -1;
    }
    
    // Adiciona o primeiro dígito verificador à base para calcular o segundo
    char cnpj_com_dv1[TAMANHO_CNPJ_SEM_DV + 2];
    sprintf(cnpj_com_dv1, "%s%d", cnpj_base, dv1);
    
    // Calcula o segundo dígito verificador
    int dv2 = calcular_digito(cnpj_com_dv1, pesos_dv2, TAMANHO_CNPJ_SEM_DV + 1);
    if (dv2 < 0) {
        return -1;
    }
    
    // Retorna os dígitos verificadores como string
    sprintf(dv, "%d%d", dv1, dv2);
    return 0;
}
