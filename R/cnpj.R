
# Constantes
TAMANHO_CNPJ_SEM_DV <- 12
TAMANHO_CNPJ_COMPLETO <- 14

# Vetores de pesos para o cálculo dos dígitos verificadores
PESOS_DV1 <- c(5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2)
PESOS_DV2 <- c(6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2)

#' Remove a máscara de formatação do CNPJ
#'
#' @param cnpj String contendo o CNPJ com ou sem máscara
#' @return String contendo o CNPJ sem máscara e em maiúsculas
#' @export
remover_mascara_cnpj <- function(cnpj) {
  # Remove pontuação e converte para maiúsculas
  cnpj_sem_mascara <- gsub("[./-]", "", cnpj)
  return(toupper(cnpj_sem_mascara))
}

#' Verifica se o CNPJ contém apenas caracteres permitidos
#'
#' @param cnpj String contendo o CNPJ a ser verificado
#' @return Valor lógico indicando se o CNPJ contém apenas caracteres permitidos
#' @export
apenas_caracteres_permitidos <- function(cnpj) {
  return(grepl("^[A-Z0-9./-]*$", cnpj))
}

#' Verifica se o CNPJ contém apenas zeros
#'
#' @param cnpj String contendo o CNPJ a ser verificado
#' @return Valor lógico indicando se o CNPJ contém apenas zeros
#' @export
apenas_zeros <- function(cnpj) {
  return(grepl("^0+$", cnpj))
}

#' Converte um caractere alfanumérico para seu valor numérico
#'
#' @param c Caractere a ser convertido
#' @return Valor numérico do caractere ou -1 em caso de erro
#' @export
converter_caractere <- function(c) {
  # Se for dígito, retorna seu valor numérico
  if (grepl("[0-9]", c)) {
    return(as.integer(c))
  } 
  # Se for letra maiúscula, retorna seu valor convertido
  else if (grepl("[A-Z]", c)) {
    return(utf8ToInt(c) - utf8ToInt("0") - 7) # 'A' (65) - '0' (48) - 7 = 10
  }
  # Caractere inválido
  return(-1)
}

#' Calcula um dígito verificador com base nos pesos fornecidos
#'
#' @param cnpj String contendo o CNPJ a ser usado no cálculo
#' @param pesos Vetor de pesos a serem aplicados
#' @return Dígito verificador calculado ou -1 em caso de erro
#' @export
calcular_digito <- function(cnpj, pesos) {
  # Verifica se o tamanho do CNPJ é compatível com os pesos
  if (nchar(cnpj) > length(pesos)) {
    return(-1)
  }
  
  soma <- 0
  
  # Calcula a soma dos produtos
  for (i in 1:nchar(cnpj)) {
    valor <- converter_caractere(substr(cnpj, i, i))
    if (valor < 0) {
      return(-1) # Caractere inválido
    }
    soma <- soma + (valor * pesos[i])
  }
  
  # Calcula o dígito verificador
  resto <- soma %% 11
  if (resto < 2) {
    return(0)
  } else {
    return(11 - resto)
  }
}

#' Valida um CNPJ alfanumérico
#'
#' @param cnpj String contendo o CNPJ a ser validado
#' @return Valor lógico indicando se o CNPJ é válido
#' @export
is_valid <- function(cnpj) {
  # Verifica se contém apenas caracteres permitidos
  if (!apenas_caracteres_permitidos(cnpj)) {
    return(FALSE)
  }
  
  # Remove máscara e converte para maiúsculas
  cnpj_sem_mascara <- remover_mascara_cnpj(cnpj)
  
  # Verifica o tamanho do CNPJ sem máscara
  if (nchar(cnpj_sem_mascara) != TAMANHO_CNPJ_COMPLETO) {
    return(FALSE)
  }
  
  # Verifica se o CNPJ não contém apenas zeros
  if (apenas_zeros(cnpj_sem_mascara)) {
    return(FALSE)
  }
  
  # Verifica se o CNPJ corresponde ao padrão correto
  if (!grepl("^([A-Z0-9]){12}(\\d){2}$", cnpj_sem_mascara)) {
    return(FALSE)
  }
  
  # Extrai os dígitos verificadores informados
  dv_informado <- substr(cnpj_sem_mascara, TAMANHO_CNPJ_SEM_DV + 1, TAMANHO_CNPJ_COMPLETO)
  
  # Calcula os dígitos verificadores
  result <- tryCatch({
    dv_calculado <- calcula_dv(substr(cnpj_sem_mascara, 1, TAMANHO_CNPJ_SEM_DV))
    # Compara os dígitos verificadores
    return(dv_informado == dv_calculado)
  }, error = function(e) {
    return(FALSE)
  })
  
  return(result)
}

#' Calcula os dígitos verificadores de um CNPJ alfanumérico
#'
#' @param cnpj String contendo a base do CNPJ
#' @return String contendo os dígitos verificadores calculados
#' @export
calcula_dv <- function(cnpj) {
  # Verifica se contém apenas caracteres permitidos
  if (!apenas_caracteres_permitidos(cnpj)) {
    stop("CNPJ contém caracteres não permitidos")
  }
  
  # Remove máscara e converte para maiúsculas
  cnpj_sem_mascara <- remover_mascara_cnpj(cnpj)
  
  # Usa apenas os primeiros 12 caracteres
  if (nchar(cnpj_sem_mascara) >= TAMANHO_CNPJ_SEM_DV) {
    cnpj_sem_mascara <- substr(cnpj_sem_mascara, 1, TAMANHO_CNPJ_SEM_DV)
  }
  
  # Verifica o tamanho da base do CNPJ
  if (nchar(cnpj_sem_mascara) != TAMANHO_CNPJ_SEM_DV) {
    stop(paste("CNPJ deve ter", TAMANHO_CNPJ_SEM_DV, "caracteres para calcular o DV"))
  }
  
  # Verifica se o CNPJ corresponde ao padrão correto
  if (!grepl("^([A-Z0-9]){12}$", cnpj_sem_mascara)) {
    stop("CNPJ não está no formato correto")
  }
  
  # Verifica se o CNPJ não contém apenas zeros
  if (apenas_zeros(cnpj_sem_mascara)) {
    stop("CNPJ não pode conter apenas zeros")
  }
  
  # Calcula o primeiro dígito verificador
  dv1 <- calcular_digito(cnpj_sem_mascara, PESOS_DV1)
  if (dv1 < 0) {
    stop("Erro ao calcular o primeiro dígito verificador")
  }
  
  # Adiciona o primeiro dígito verificador à base para calcular o segundo
  cnpj_com_dv1 <- paste0(cnpj_sem_mascara, dv1)
  
  # Calcula o segundo dígito verificador
  dv2 <- calcular_digito(cnpj_com_dv1, PESOS_DV2)
  if (dv2 < 0) {
    stop("Erro ao calcular o segundo dígito verificador")
  }
  
  # Retorna os dígitos verificadores como string
  return(paste0(dv1, dv2))
}
