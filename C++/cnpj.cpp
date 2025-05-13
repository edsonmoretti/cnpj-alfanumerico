#include "cnpj.h"
#include <algorithm>
#include <cctype>

// Inicialização das constantes estáticas
const std::vector<int> CNPJ::PESOS_DV1 = {5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
const std::vector<int> CNPJ::PESOS_DV2 = {6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};

const std::regex CNPJ::REGEX_CNPJ(R"(^([A-Z\d]){12}(\d){2}$)");
const std::regex CNPJ::REGEX_CNPJ_SEM_DV(R"(^([A-Z\d]){12}$)");
const std::regex CNPJ::REGEX_CARACTERES_MASCARA(R"([./-])");
const std::regex CNPJ::REGEX_CARACTERES_PERMITIDOS(R"(^[A-Z\d./-]*$)");

bool CNPJ::isValid(const std::string& cnpj) {
    // Verifica se contém apenas caracteres permitidos
    if (!std::regex_match(cnpj, REGEX_CARACTERES_PERMITIDOS)) {
        return false;
    }

    // Remove máscara e converte para maiúsculas
    std::string cnpjSemMascara = removeMascaraCNPJ(cnpj);
    
    // Verifica o tamanho do CNPJ sem máscara
    if (cnpjSemMascara.size() != TAMANHO_CNPJ_COMPLETO) {
        return false;
    }
    
    // Verifica se o CNPJ não contém apenas zeros
    if (apenasZeros(cnpjSemMascara)) {
        return false;
    }
    
    // Verifica se o CNPJ corresponde ao padrão correto
    if (!std::regex_match(cnpjSemMascara, REGEX_CNPJ)) {
        return false;
    }
    
    // Extrai os dígitos verificadores informados
    std::string dvInformado = cnpjSemMascara.substr(TAMANHO_CNPJ_SEM_DV, 2);
    
    // Calcula os dígitos verificadores
    auto dvCalculado = calculaDV(cnpjSemMascara.substr(0, TAMANHO_CNPJ_SEM_DV));
    if (!dvCalculado) {
        return false;
    }
    
    // Compara os dígitos verificadores
    return dvInformado == *dvCalculado;
}

std::optional<std::string> CNPJ::calculaDV(const std::string& cnpj) {
    // Verifica se contém apenas caracteres permitidos
    if (!std::regex_match(cnpj, REGEX_CARACTERES_PERMITIDOS)) {
        return std::nullopt;
    }
    
    // Remove máscara e converte para maiúsculas
    std::string cnpjSemMascara = removeMascaraCNPJ(cnpj);
    
    // Usa apenas os primeiros 12 caracteres
    if (cnpjSemMascara.size() >= TAMANHO_CNPJ_SEM_DV) {
        cnpjSemMascara = cnpjSemMascara.substr(0, TAMANHO_CNPJ_SEM_DV);
    }
    
    // Verifica o tamanho da base do CNPJ
    if (cnpjSemMascara.size() != TAMANHO_CNPJ_SEM_DV) {
        return std::nullopt;
    }
    
    // Verifica se o CNPJ corresponde ao padrão correto
    if (!std::regex_match(cnpjSemMascara, REGEX_CNPJ_SEM_DV)) {
        return std::nullopt;
    }
    
    // Verifica se o CNPJ não contém apenas zeros
    if (apenasZeros(cnpjSemMascara)) {
        return std::nullopt;
    }
    
    // Calcula o primeiro dígito verificador
    int dv1 = calcularDigito(cnpjSemMascara, PESOS_DV1);
    if (dv1 < 0) {
        return std::nullopt;
    }
    
    // Adiciona o primeiro dígito verificador à base para calcular o segundo
    std::string cnpjComDv1 = cnpjSemMascara + std::to_string(dv1);
    
    // Calcula o segundo dígito verificador
    int dv2 = calcularDigito(cnpjComDv1, PESOS_DV2);
    if (dv2 < 0) {
        return std::nullopt;
    }
    
    // Retorna os dígitos verificadores como string
    return std::to_string(dv1) + std::to_string(dv2);
}

std::string CNPJ::removeMascaraCNPJ(const std::string& cnpj) {
    // Remove caracteres de máscara
    std::string resultado = std::regex_replace(cnpj, REGEX_CARACTERES_MASCARA, "");
    
    // Converte para maiúsculas
    std::transform(resultado.begin(), resultado.end(), resultado.begin(), 
                  [](unsigned char c) { return std::toupper(c); });
    
    return resultado;
}

int CNPJ::converterCaractere(char c) {
    // Se for dígito, retorna seu valor numérico
    if (std::isdigit(c)) {
        return c - '0';
    }
    // Se for letra maiúscula, retorna seu valor convertido (A=10, B=11, ...)
    else if (std::isupper(c)) {
        return (c - '0') - 7; // 'A' (65) - '0' (48) - 7 = 10
    }
    // Caractere inválido
    return -1;
}

bool CNPJ::apenasZeros(const std::string& cnpj) {
    return std::all_of(cnpj.begin(), cnpj.end(), [](char c) { return c == '0'; });
}

int CNPJ::calcularDigito(const std::string& cnpj, const std::vector<int>& pesos) {
    int soma = 0;
    
    // Verifica se o tamanho do CNPJ é compatível com os pesos
    if (cnpj.size() > pesos.size()) {
        return -1;
    }
    
    // Calcula a soma dos produtos
    for (size_t i = 0; i < cnpj.size(); i++) {
        int valor = converterCaractere(cnpj[i]);
        if (valor < 0) {
            return -1; // Caractere inválido
        }
        soma += valor * pesos[i];
    }
    
    // Calcula o dígito verificador
    int resto = soma % 11;
    if (resto < 2) {
        return 0;
    } else {
        return 11 - resto;
    }
}
