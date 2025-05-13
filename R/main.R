
# Carregar as funções de validação
source("cnpj.R")

# Função para exibir instruções de uso
print_usage <- function() {
  cat("Uso:\n")
  cat("  Para validar: Rscript main.R -v CNPJ1 [CNPJ2 CNPJ3 ...]\n")
  cat("  Para calcular DV: Rscript main.R -dv CNPJ1 [CNPJ2 CNPJ3 ...]\n")
  cat("\nExemplos:\n")
  cat("  Rscript main.R -v 12ABC34501DE35\n")
  cat("  Rscript main.R -dv 12ABC34501DE\n")
}

# Processar argumentos da linha de comando
args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 2) {
  cat("Erro: Argumentos insuficientes\n")
  print_usage()
  quit(status = 1)
}

# Verificar a operação solicitada
operacao <- tolower(args[1])
cnpjs <- args[-1]  # Remover a operação da lista

if (operacao == "-v") {
  # Modo de validação
  for (i in seq_along(cnpjs)) {
    cnpj_str <- toupper(cnpjs[i])
    
    resultado <- tryCatch({
      if (is_valid(cnpj_str)) {
        cat(sprintf("[%d] CNPJ: [%s] ✓ Válido\n", i, cnpj_str))
      } else {
        cat(sprintf("[%d] CNPJ: [%s] ✗ Inválido\n", i, cnpj_str))
      }
    }, error = function(e) {
      cat(sprintf("[%d] Erro ao validar CNPJ [%s]: %s\n", i, cnpj_str, e$message))
    })
  }
} else if (operacao == "-dv") {
  # Modo de cálculo de DV
  for (i in seq_along(cnpjs)) {
    cnpj_str <- toupper(cnpjs[i])
    
    resultado <- tryCatch({
      dv <- calcula_dv(cnpj_str)
      cat(sprintf("[%d] CNPJ: [%s] DV: [%s]\n", i, cnpj_str, dv))
      cnpj_sem_mascara <- remover_mascara_cnpj(cnpj_str)
      cat(sprintf("    CNPJ Completo: %s%s\n", cnpj_sem_mascara, dv))
    }, error = function(e) {
      cat(sprintf("[%d] Erro ao calcular DV para CNPJ [%s]: %s\n", i, cnpj_str, e$message))
    })
  }
} else {
  cat(sprintf("Erro: Operação desconhecida '%s'\n", operacao))
  print_usage()
  quit(status = 1)
}
