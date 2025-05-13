#ifndef CNPJ_H
#define CNPJ_H

#include <stdbool.h>

/**
 * Verifica se um CNPJ alfanumérico é válido
 * 
 * @param cnpj O CNPJ a ser validado
 * @return true se o CNPJ for válido, false caso contrário
 */
bool is_valid(const char* cnpj);

/**
 * Calcula os dígitos verificadores de um CNPJ alfanumérico
 * 
 * @param cnpj A base do CNPJ (12 caracteres alfanuméricos)
 * @param dv Array para armazenar os dígitos verificadores calculados (deve ter tamanho >= 3)
 * @return 0 se o cálculo for bem-sucedido, -1 em caso de erro
 */
int calcula_dv(const char* cnpj, char* dv);

/**
 * Remove a máscara de formatação do CNPJ
 * 
 * @param cnpj O CNPJ com máscara
 * @param cnpj_sem_mascara Buffer para armazenar o CNPJ sem máscara
 * @param tamanho Tamanho do buffer
 */
void remove_mascara_cnpj(const char* cnpj, char* cnpj_sem_mascara, int tamanho);

#endif /* CNPJ_H */
