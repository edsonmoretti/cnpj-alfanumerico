# Classe para validação e cálculo de dígitos verificadores de CNPJ alfanumérico
class CNPJ
  TAMANHO_CNPJ_SEM_DV = 12
  TAMANHO_CNPJ_COMPLETO = 14
  
  PESOS_DV1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
  PESOS_DV2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
  
  REGEX_CNPJ = /^([A-Z\d]){12}(\d){2}$/
  REGEX_CNPJ_SEM_DV = /^([A-Z\d]){12}$/
  REGEX_CARACTERES_MASCARA = /[.\/-]/
  REGEX_CARACTERES_PERMITIDOS = /^[A-Z\d.\/-]*$/
  
  # Verifica se um CNPJ alfanumérico é válido
  # @param cnpj [String] CNPJ a ser validado
  # @return [Boolean] true se o CNPJ for válido, false caso contrário
  def self.valid?(cnpj)
    # Verifica se contém apenas caracteres permitidos
    unless cnpj.match?(REGEX_CARACTERES_PERMITIDOS)
      return false
    end
    
    # Remove máscara e converte para maiúsculas
    cnpj_sem_mascara = remover_mascara(cnpj.upcase)
    
    # Verifica o tamanho do CNPJ sem máscara
    return false unless cnpj_sem_mascara.length == TAMANHO_CNPJ_COMPLETO
    
    # Verifica se o CNPJ não contém apenas zeros
    return false if apenas_zeros?(cnpj_sem_mascara)
    
    # Verifica se o CNPJ corresponde ao padrão correto
    return false unless cnpj_sem_mascara.match?(REGEX_CNPJ)
    
    # Extrai os dígitos verificadores informados
    dv_informado = cnpj_sem_mascara[TAMANHO_CNPJ_SEM_DV..-1]
    
    # Calcula os dígitos verificadores
    begin
      dv_calculado = calcular_dv(cnpj_sem_mascara[0...TAMANHO_CNPJ_SEM_DV])
      
      # Compara os dígitos verificadores
      return dv_informado == dv_calculado
    rescue => e
      return false
    end
  end
  
  # Calcula os dígitos verificadores de um CNPJ alfanumérico
  # @param cnpj [String] Base do CNPJ (12 caracteres alfanuméricos)
  # @return [String] Dígitos verificadores calculados
  # @raise [ArgumentError] Se o CNPJ for inválido
  def self.calcular_dv(cnpj)
    # Verifica se contém apenas caracteres permitidos
    unless cnpj.match?(REGEX_CARACTERES_PERMITIDOS)
      raise ArgumentError, "CNPJ contém caracteres não permitidos"
    end
    
    # Remove máscara e converte para maiúsculas
    cnpj_sem_mascara = remover_mascara(cnpj.upcase)
    
    # Usa apenas os primeiros 12 caracteres
    cnpj_sem_mascara = cnpj_sem_mascara[0...TAMANHO_CNPJ_SEM_DV] if cnpj_sem_mascara.length >= TAMANHO_CNPJ_SEM_DV
    
    # Verifica o tamanho da base do CNPJ
    unless cnpj_sem_mascara.length == TAMANHO_CNPJ_SEM_DV
      raise ArgumentError, "CNPJ deve ter #{TAMANHO_CNPJ_SEM_DV} caracteres para calcular o DV"
    end
    
    # Verifica se o CNPJ corresponde ao padrão correto
    unless cnpj_sem_mascara.match?(REGEX_CNPJ_SEM_DV)
      raise ArgumentError, "CNPJ não está no formato correto"
    end
    
    # Verifica se o CNPJ não contém apenas zeros
    if apenas_zeros?(cnpj_sem_mascara)
      raise ArgumentError, "CNPJ não pode conter apenas zeros"
    end
    
    # Calcula o primeiro dígito verificador
    dv1 = calcular_digito(cnpj_sem_mascara, PESOS_DV1)
    
    # Adiciona o primeiro dígito verificador à base para calcular o segundo
    cnpj_com_dv1 = "#{cnpj_sem_mascara}#{dv1}"
    
    # Calcula o segundo dígito verificador
    dv2 = calcular_digito(cnpj_com_dv1, PESOS_DV2)
    
    # Retorna os dígitos verificadores como string
    "#{dv1}#{dv2}"
  end
  
  # Remove a máscara de formatação do CNPJ
  # @param cnpj [String] CNPJ com máscara
  # @return [String] CNPJ sem máscara
  def self.remover_mascara(cnpj)
    cnpj.gsub(REGEX_CARACTERES_MASCARA, '')
  end
  
  private
  
  # Converte um caractere alfanumérico para seu valor numérico
  # @param caractere [String] Caractere a ser convertido
  # @return [Integer] Valor numérico do caractere
  # @raise [ArgumentError] Se o caractere for inválido
  def self.converter_caractere(caractere)
    # Valor ASCII do caractere
    ascii = caractere.ord
    
    # Se for dígito, retorna seu valor numérico
    if caractere.match?(/\d/)
      return caractere.to_i
    # Se for letra maiúscula, retorna seu valor convertido
    elsif caractere.match?(/[A-Z]/)
      return ascii - 48 - 7  # 'A' (65) - '0' (48) - 7 = 10
    else
      # Caractere inválido
      raise ArgumentError, "Caractere inválido: #{caractere}"
    end
  end
  
  # Verifica se um CNPJ contém apenas zeros
  # @param cnpj [String] CNPJ a ser verificado
  # @return [Boolean] true se o CNPJ contiver apenas zeros, false caso contrário
  def self.apenas_zeros?(cnpj)
    cnpj.chars.all? { |c| c == '0' }
  end
  
  # Calcula um dígito verificador com base nos pesos fornecidos
  # @param cnpj [String] CNPJ a ser usado no cálculo
  # @param pesos [Array<Integer>] Pesos a serem aplicados
  # @return [Integer] Dígito verificador calculado
  # @raise [ArgumentError] Se o tamanho do CNPJ for incompatível com os pesos
  def self.calcular_digito(cnpj, pesos)
    # Verifica se o tamanho do CNPJ é compatível com os pesos
    if cnpj.length > pesos.length
      raise ArgumentError, "Tamanho do CNPJ incompatível com os pesos"
    end
    
    soma = 0
    
    # Calcula a soma dos produtos
    cnpj.chars.each_with_index do |caractere, i|
      valor = converter_caractere(caractere)
      soma += valor * pesos[i]
    end
    
    # Calcula o dígito verificador
    resto = soma % 11
    
    if resto < 2
      return 0
    else
      return 11 - resto
    end
  end
end
