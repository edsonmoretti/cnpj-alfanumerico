package com.edsonmoretti.cnpj

/**
 * Classe para validação e cálculo de dígitos verificadores de CNPJ alfanumérico
 */
class CNPJ {
    companion object {
        private const val TAMANHO_CNPJ_SEM_DV = 12
        private const val TAMANHO_CNPJ_COMPLETO = 14
        
        private val PESOS_DV1 = intArrayOf(5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2)
        private val PESOS_DV2 = intArrayOf(6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2)
        
        private val REGEX_CNPJ = Regex("^([A-Z\\d]){12}(\\d){2}$")
        private val REGEX_CNPJ_SEM_DV = Regex("^([A-Z\\d]){12}$")
        private val REGEX_CARACTERES_MASCARA = Regex("[./-]")
        private val REGEX_CARACTERES_PERMITIDOS = Regex("^[A-Z\\d./-]*$")
        
        /**
         * Verifica se um CNPJ alfanumérico é válido
         * 
         * @param cnpj O CNPJ a ser validado
         * @return true se o CNPJ for válido, false caso contrário
         */
        fun isValid(cnpj: String): Boolean {
            // Verifica se contém apenas caracteres permitidos
            if (!cnpj.matches(REGEX_CARACTERES_PERMITIDOS)) {
                return false
            }

            // Remove máscara e converte para maiúsculas
            val cnpjSemMascara = removeMascaraCNPJ(cnpj.toUpperCase())
            
            // Verifica o tamanho do CNPJ sem máscara
            if (cnpjSemMascara.length != TAMANHO_CNPJ_COMPLETO) {
                return false
            }
            
            // Verifica se o CNPJ não contém apenas zeros
            if (apenasZeros(cnpjSemMascara)) {
                return false
            }
            
            // Verifica se o CNPJ corresponde ao padrão correto
            if (!cnpjSemMascara.matches(REGEX_CNPJ)) {
                return false
            }
            
            // Extrai os dígitos verificadores informados
            val dvInformado = cnpjSemMascara.substring(TAMANHO_CNPJ_SEM_DV)
            
            // Calcula os dígitos verificadores
            try {
                val dvCalculado = calculaDV(cnpjSemMascara.substring(0, TAMANHO_CNPJ_SEM_DV))
                
                // Compara os dígitos verificadores
                return dvInformado == dvCalculado
            } catch (e: Exception) {
                return false
            }
        }

        /**
         * Calcula os dígitos verificadores de um CNPJ alfanumérico
         * 
         * @param cnpj A base do CNPJ (12 caracteres alfanuméricos)
         * @return Os dígitos verificadores calculados
         * @throws IllegalArgumentException se o CNPJ for inválido
         */
        fun calculaDV(cnpj: String): String {
            // Verifica se contém apenas caracteres permitidos
            if (!cnpj.matches(REGEX_CARACTERES_PERMITIDOS)) {
                throw IllegalArgumentException("CNPJ contém caracteres não permitidos")
            }
            
            // Remove máscara e converte para maiúsculas
            val cnpjSemMascara = removeMascaraCNPJ(cnpj.toUpperCase())
            
            // Usa apenas os primeiros 12 caracteres
            val cnpjBase = if (cnpjSemMascara.length >= TAMANHO_CNPJ_SEM_DV) {
                cnpjSemMascara.substring(0, TAMANHO_CNPJ_SEM_DV)
            } else {
                cnpjSemMascara
            }
            
            // Verifica o tamanho da base do CNPJ
            if (cnpjBase.length != TAMANHO_CNPJ_SEM_DV) {
                throw IllegalArgumentException("CNPJ deve ter $TAMANHO_CNPJ_SEM_DV caracteres para calcular o DV")
            }
            
            // Verifica se o CNPJ corresponde ao padrão correto
            if (!cnpjBase.matches(REGEX_CNPJ_SEM_DV)) {
                throw IllegalArgumentException("CNPJ não está no formato correto")
            }
            
            // Verifica se o CNPJ não contém apenas zeros
            if (apenasZeros(cnpjBase)) {
                throw IllegalArgumentException("CNPJ não pode conter apenas zeros")
            }
            
            // Calcula o primeiro dígito verificador
            val dv1 = calcularDigito(cnpjBase, PESOS_DV1)
            
            // Adiciona o primeiro dígito verificador à base para calcular o segundo
            val cnpjComDv1 = cnpjBase + dv1
            
            // Calcula o segundo dígito verificador
            val dv2 = calcularDigito(cnpjComDv1, PESOS_DV2)
            
            // Retorna os dígitos verificadores como string
            return "$dv1$dv2"
        }

        /**
         * Remove a máscara de formatação do CNPJ
         * 
         * @param cnpj O CNPJ com máscara
         * @return O CNPJ sem máscara
         */
        fun removeMascaraCNPJ(cnpj: String): String {
            return cnpj.replace(REGEX_CARACTERES_MASCARA, "")
        }

        /**
         * Converte um caractere alfanumérico para seu valor numérico
         * 
         * @param c O caractere a ser convertido
         * @return O valor numérico do caractere
         * @throws IllegalArgumentException se o caractere for inválido
         */
        private fun converterCaractere(c: Char): Int {
            // Se for dígito, retorna seu valor numérico
            if (c.isDigit()) {
                return c - '0'
            }
            // Se for letra maiúscula, retorna seu valor convertido
            else if (c.isUpperCase()) {
                return (c.code - '0'.code) - 7 // 'A' (65) - '0' (48) - 7 = 10
            }
            // Caractere inválido
            throw IllegalArgumentException("Caractere inválido: $c")
        }

        /**
         * Verifica se um CNPJ contém apenas zeros
         * 
         * @param cnpj O CNPJ a ser verificado
         * @return true se o CNPJ contiver apenas zeros, false caso contrário
         */
        private fun apenasZeros(cnpj: String): Boolean {
            return cnpj.all { it == '0' }
        }

        /**
         * Calcula um dígito verificador com base nos pesos fornecidos
         * 
         * @param cnpj O CNPJ a ser usado no cálculo
         * @param pesos Os pesos a serem aplicados
         * @return O dígito verificador calculado
         * @throws IllegalArgumentException se o tamanho do CNPJ for incompatível com os pesos
         */
        private fun calcularDigito(cnpj: String, pesos: IntArray): Int {
            if (cnpj.length > pesos.size) {
                throw IllegalArgumentException("Tamanho do CNPJ incompatível com os pesos")
            }
            
            var soma = 0
            
            // Calcula a soma dos produtos
            for (i in cnpj.indices) {
                val valor = converterCaractere(cnpj[i])
                soma += valor * pesos[i]
            }
            
            // Calcula o dígito verificador
            val resto = soma % 11
            return if (resto < 2) {
                0
            } else {
                11 - resto
            }
        }
    }
}
