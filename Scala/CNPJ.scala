package com.edsonmoretti.cnpj

import scala.util.matching.Regex

/**
 * Objeto para validação e cálculo de dígitos verificadores de CNPJ alfanumérico
 */
object CNPJ {
  private val TamanhoCnpjSemDv: Int = 12
  private val TamanhoCnpjCompleto: Int = 14
  
  private val RegexCnpj: Regex = """^([A-Z\d]){12}(\d){2}$""".r
  private val RegexCnpjSemDv: Regex = """^([A-Z\d]){12}$""".r
  private val RegexCaracteresMascara: Regex = """[./-]""".r
  private val RegexCaracteresPermitidos: Regex = """^[A-Z\d./-]*$""".r
  
  private val PesosDv1: Array[Int] = Array(5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2)
  private val PesosDv2: Array[Int] = Array(6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2)
  
  /**
   * Verifica se um CNPJ alfanumérico é válido
   * 
   * @param cnpj O CNPJ a ser validado
   * @return true se o CNPJ for válido, false caso contrário
   */
  def isValid(cnpj: String): Boolean = {
    // Verifica se contém apenas caracteres permitidos
    if (!RegexCaracteresPermitidos.pattern.matcher(cnpj).matches()) {
      return false
    }

    // Remove máscara e converte para maiúsculas
    val cnpjSemMascara = removeMascaraCnpj(cnpj.toUpperCase())
    
    // Verifica o tamanho do CNPJ sem máscara
    if (cnpjSemMascara.length != TamanhoCnpjCompleto) {
      return false
    }
    
    // Verifica se o CNPJ não contém apenas zeros
    if (apenasZeros(cnpjSemMascara)) {
      return false
    }
    
    // Verifica se o CNPJ corresponde ao padrão correto
    if (!RegexCnpj.pattern.matcher(cnpjSemMascara).matches()) {
      return false
    }
    
    // Extrai os dígitos verificadores informados
    val dvInformado = cnpjSemMascara.substring(TamanhoCnpjSemDv)
    
    // Calcula os dígitos verificadores
    try {
      val dvCalculado = calculaDV(cnpjSemMascara.substring(0, TamanhoCnpjSemDv))
      
      // Compara os dígitos verificadores
      return dvInformado == dvCalculado
    } catch {
      case _: Exception => false
    }
  }
  
  /**
   * Calcula os dígitos verificadores de um CNPJ alfanumérico
   * 
   * @param cnpj A base do CNPJ (12 caracteres alfanuméricos)
   * @return Os dígitos verificadores calculados
   * @throws IllegalArgumentException se o CNPJ for inválido
   */
  def calculaDV(cnpj: String): String = {
    // Verifica se contém apenas caracteres permitidos
    if (!RegexCaracteresPermitidos.pattern.matcher(cnpj).matches()) {
      throw new IllegalArgumentException("CNPJ contém caracteres não permitidos")
    }
    
    // Remove máscara e converte para maiúsculas
    val cnpjSemMascara = removeMascaraCnpj(cnpj.toUpperCase())
    
    // Usa apenas os primeiros 12 caracteres
    val cnpjBase = if (cnpjSemMascara.length >= TamanhoCnpjSemDv) {
      cnpjSemMascara.substring(0, TamanhoCnpjSemDv)
    } else {
      cnpjSemMascara
    }
    
    // Verifica o tamanho da base do CNPJ
    if (cnpjBase.length != TamanhoCnpjSemDv) {
      throw new IllegalArgumentException(s"CNPJ deve ter $TamanhoCnpjSemDv caracteres para calcular o DV")
    }
    
    // Verifica se o CNPJ corresponde ao padrão correto
    if (!RegexCnpjSemDv.pattern.matcher(cnpjBase).matches()) {
      throw new IllegalArgumentException("CNPJ não está no formato correto")
    }
    
    // Verifica se o CNPJ não contém apenas zeros
    if (apenasZeros(cnpjBase)) {
      throw new IllegalArgumentException("CNPJ não pode conter apenas zeros")
    }
    
    // Calcula o primeiro dígito verificador
    val dv1 = calcularDigito(cnpjBase, PesosDv1)
    
    // Adiciona o primeiro dígito verificador à base para calcular o segundo
    val cnpjComDv1 = cnpjBase + dv1
    
    // Calcula o segundo dígito verificador
    val dv2 = calcularDigito(cnpjComDv1, PesosDv2)
    
    // Retorna os dígitos verificadores como string
    s"$dv1$dv2"
  }
  
  /**
   * Remove a máscara de formatação do CNPJ
   * 
   * @param cnpj O CNPJ com máscara
   * @return O CNPJ sem máscara
   */
  def removeMascaraCnpj(cnpj: String): String = {
    RegexCaracteresMascara.replaceAllIn(cnpj, "")
  }
  
  /**
   * Converte um caractere alfanumérico para seu valor numérico
   * 
   * @param c O caractere a ser convertido
   * @return O valor numérico do caractere
   * @throws IllegalArgumentException se o caractere for inválido
   */
  private def converterCaractere(c: Char): Int = {
    // Se for dígito, retorna seu valor numérico
    if (c.isDigit) {
      c - '0'
    }
    // Se for letra maiúscula, retorna seu valor convertido
    else if (c.isUpper) {
      (c - '0') - 7 // 'A' (65) - '0' (48) - 7 = 10
    }
    // Caractere inválido
    else {
      throw new IllegalArgumentException(s"Caractere inválido: $c")
    }
  }
  
  /**
   * Verifica se um CNPJ contém apenas zeros
   * 
   * @param cnpj O CNPJ a ser verificado
   * @return true se o CNPJ contiver apenas zeros, false caso contrário
   */
  private def apenasZeros(cnpj: String): Boolean = {
    cnpj.forall(_ == '0')
  }
  
  /**
   * Calcula um dígito verificador com base nos pesos fornecidos
   * 
   * @param cnpj O CNPJ a ser usado no cálculo
   * @param pesos Os pesos a serem aplicados
   * @return O dígito verificador calculado
   * @throws IllegalArgumentException se o tamanho do CNPJ for incompatível com os pesos
   */
  private def calcularDigito(cnpj: String, pesos: Array[Int]): Char = {
    // Verifica se o tamanho do CNPJ é compatível com os pesos
    if (cnpj.length > pesos.length) {
      throw new IllegalArgumentException("Tamanho do CNPJ incompatível com os pesos")
    }
    
    // Calcula a soma dos produtos
    val soma = cnpj.zipWithIndex.map { case (c, i) => 
      val valor = converterCaractere(c)
      valor * pesos(i)
    }.sum
    
    // Calcula o dígito verificador
    val resto = soma % 11
    val dv = if (resto < 2) {
      '0'
    } else {
      ('0' + (11 - resto)).toChar
    }
    
    dv
  }
}
