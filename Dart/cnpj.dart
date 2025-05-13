import 'dart:math';

/// Classe para validação e cálculo de dígitos verificadores de CNPJs alfanuméricos
class CNPJ {
  /// Tamanho do CNPJ sem os dígitos verificadores
  static const int tamanhoCnpjSemDv = 12;
  
  /// Tamanho do CNPJ completo
  static const int tamanhoCnpjCompleto = 14;
  
  /// Padrão Regex para validar CNPJs alfanuméricos completos
  static final RegExp regexCnpj = RegExp(r'^([A-Z\d]){12}(\d){2}$');
  
  /// Padrão Regex para validar bases de CNPJs alfanuméricos (sem DVs)
  static final RegExp regexCnpjSemDv = RegExp(r'^([A-Z\d]){12}$');
  
  /// Padrão Regex para identificar caracteres de máscara
  static final RegExp regexCaracteresMascara = RegExp(r'[./-]');
  
  /// Padrão Regex para validar caracteres permitidos (incluindo máscara)
  static final RegExp regexCaracteresPermitidos = RegExp(r'^[A-Z\d./-]*$');
  
  /// Pesos para o cálculo do primeiro dígito verificador
  static const List<int> pesosDv1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
  
  /// Pesos para o cálculo do segundo dígito verificador
  static const List<int> pesosDv2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

  /// Verifica se um CNPJ alfanumérico é válido
  /// 
  /// Retorna `true` se o CNPJ é válido, ou `false` caso contrário
  static bool isValid(String cnpj) {
    // Verifica se o CNPJ contém apenas caracteres permitidos
    if (!regexCaracteresPermitidos.hasMatch(cnpj)) {
      return false;
    }

    // Remove máscara e converte para maiúsculas
    String cnpjSemMascara = removeMascaraCnpj(cnpj.toUpperCase());
    
    // Verifica o tamanho do CNPJ sem máscara
    if (cnpjSemMascara.length != tamanhoCnpjCompleto) {
      return false;
    }
    
    // Verifica se o CNPJ não contém apenas zeros
    if (apenasZeros(cnpjSemMascara)) {
      return false;
    }
    
    // Verifica se o CNPJ corresponde ao padrão correto
    if (!regexCnpj.hasMatch(cnpjSemMascara)) {
      return false;
    }
    
    // Extrai os dígitos verificadores informados
    String dvInformado = cnpjSemMascara.substring(tamanhoCnpjSemDv);
    
    // Calcula os dígitos verificadores
    try {
      String dvCalculado = calculaDV(cnpjSemMascara.substring(0, tamanhoCnpjSemDv));
      
      // Compara os dígitos verificadores
      return dvInformado == dvCalculado;
    } catch (e) {
      return false;
    }
  }

  /// Calcula os dígitos verificadores de um CNPJ alfanumérico
  /// 
  /// Retorna uma string contendo os dois dígitos verificadores
  /// ou lança uma exceção em caso de erro
  static String calculaDV(String cnpj) {
    // Verifica se o CNPJ contém apenas caracteres permitidos
    if (!regexCaracteresPermitidos.hasMatch(cnpj)) {
      throw ArgumentError('CNPJ contém caracteres não permitidos');
    }
    
    // Remove máscara e converte para maiúsculas
    String cnpjSemMascara = removeMascaraCnpj(cnpj.toUpperCase());
    
    // Usa apenas os primeiros 12 caracteres
    if (cnpjSemMascara.length >= tamanhoCnpjSemDv) {
      cnpjSemMascara = cnpjSemMascara.substring(0, tamanhoCnpjSemDv);
    }
    
    // Verifica o tamanho da base do CNPJ
    if (cnpjSemMascara.length != tamanhoCnpjSemDv) {
      throw ArgumentError('CNPJ deve ter $tamanhoCnpjSemDv caracteres para calcular o DV');
    }
    
    // Verifica se o CNPJ corresponde ao padrão correto
    if (!regexCnpjSemDv.hasMatch(cnpjSemMascara)) {
      throw ArgumentError('CNPJ não está no formato correto');
    }
    
    // Verifica se o CNPJ não contém apenas zeros
    if (apenasZeros(cnpjSemMascara)) {
      throw ArgumentError('CNPJ não pode conter apenas zeros');
    }
    
    // Calcula o primeiro dígito verificador
    int dv1 = calcularDigito(cnpjSemMascara, pesosDv1);
    
    // Adiciona o primeiro dígito verificador à base para calcular o segundo
    String cnpjComDv1 = cnpjSemMascara + dv1.toString();
    
    // Calcula o segundo dígito verificador
    int dv2 = calcularDigito(cnpjComDv1, pesosDv2);
    
    // Retorna os dígitos verificadores como string
    return '$dv1$dv2';
  }

  /// Remove a máscara de formatação do CNPJ
  /// 
  /// Retorna o CNPJ sem caracteres de formatação
  static String removeMascaraCnpj(String cnpj) {
    return cnpj.replaceAll(regexCaracteresMascara, '');
  }

  /// Converte um caractere alfanumérico para seu valor numérico
  /// 
  /// Retorna o valor numérico equivalente ao caractere
  static int converterCaractere(String caractere) {
    // Pega o código ASCII do caractere
    int ascii = caractere.codeUnitAt(0);
    
    // Se for dígito, retorna seu valor numérico
    if (ascii >= 48 && ascii <= 57) {
      return ascii - 48;
    }
    // Se for letra maiúscula, retorna seu valor convertido
    else if (ascii >= 65 && ascii <= 90) {
      return ascii - 48 - 7; // Convertendo para A=10, B=11, etc.
    }
    // Caractere inválido
    throw ArgumentError('Caractere inválido: $caractere');
  }

  /// Verifica se um CNPJ contém apenas zeros
  /// 
  /// Retorna `true` se o CNPJ contiver apenas zeros, `false` caso contrário
  static bool apenasZeros(String cnpj) {
    return RegExp(r'^0+$').hasMatch(cnpj);
  }

  /// Calcula um dígito verificador com base nos pesos fornecidos
  /// 
  /// Retorna o dígito verificador calculado
  static int calcularDigito(String cnpj, List<int> pesos) {
    if (cnpj.length > pesos.length) {
      throw ArgumentError('Tamanho do CNPJ incompatível com os pesos');
    }
    
    int soma = 0;
    
    // Calcula a soma dos produtos
    for (int i = 0; i < cnpj.length; i++) {
      int valor = converterCaractere(cnpj[i]);
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
}
