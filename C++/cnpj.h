#ifndef CNPJ_H
#define CNPJ_H

#include <string>
#include <optional>
#include <vector>
#include <regex>

class CNPJ {
public:
    /**
     * Verifica se um CNPJ alfanumérico é válido
     * 
     * @param cnpj O CNPJ a ser validado
     * @return true se o CNPJ for válido, false caso contrário
     */
    static bool isValid(const std::string& cnpj);

    /**
     * Calcula os dígitos verificadores de um CNPJ alfanumérico
     * 
     * @param cnpj A base do CNPJ (12 caracteres alfanuméricos)
     * @return Um opcional contendo os dígitos verificadores, ou std::nullopt em caso de erro
     */
    static std::optional<std::string> calculaDV(const std::string& cnpj);

private:
    static constexpr int TAMANHO_CNPJ_SEM_DV = 12;
    static constexpr int TAMANHO_CNPJ_COMPLETO = 14;
    
    static const std::vector<int> PESOS_DV1;
    static const std::vector<int> PESOS_DV2;
    
    static const std::regex REGEX_CNPJ;
    static const std::regex REGEX_CNPJ_SEM_DV;
    static const std::regex REGEX_CARACTERES_MASCARA;
    static const std::regex REGEX_CARACTERES_PERMITIDOS;
    
    /**
     * Remove a máscara de formatação do CNPJ
     * 
     * @param cnpj O CNPJ com máscara
     * @return O CNPJ sem máscara e em maiúsculas
     */
    static std::string removeMascaraCNPJ(const std::string& cnpj);
    
    /**
     * Converte um caractere alfanumérico para seu valor numérico
     * 
     * @param c O caractere a ser convertido
     * @return O valor numérico do caractere, ou -1 em caso de erro
     */
    static int converterCaractere(char c);
    
    /**
     * Verifica se um CNPJ contém apenas zeros
     * 
     * @param cnpj O CNPJ a ser verificado
     * @return true se o CNPJ contiver apenas zeros, false caso contrário
     */
    static bool apenasZeros(const std::string& cnpj);
    
    /**
     * Calcula um dígito verificador com base nos pesos fornecidos
     * 
     * @param cnpj O CNPJ a ser usado no cálculo
     * @param pesos Os pesos a serem aplicados
     * @return O dígito verificador calculado, ou -1 em caso de erro
     */
    static int calcularDigito(const std::string& cnpj, const std::vector<int>& pesos);
};

#endif // CNPJ_H
