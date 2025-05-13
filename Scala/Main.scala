package com.edsonmoretti.cnpj

/**
 * Programa principal para validação e cálculo de DV de CNPJ alfanumérico
 */
object Main {
  def main(args: Array[String]): Unit = {
    if (args.length < 2) {
      System.err.println("Erro: Argumentos insuficientes")
      printUsage()
      System.exit(1)
    }

    // Verifica a operação solicitada
    val operacao = args(0).toLowerCase
    
    // Lista de CNPJs (excluindo o primeiro argumento que é a operação)
    val cnpjs = args.tail

    operacao match {
      case "-v" =>
        // Modo de validação
        cnpjs.zipWithIndex.foreach { case (cnpj, index) =>
          val cnpjUpper = cnpj.toUpperCase
          
          try {
            if (CNPJ.isValid(cnpjUpper)) {
              println(s"[${index + 1}] CNPJ: [$cnpjUpper] ✓ Válido")
            } else {
              println(s"[${index + 1}] CNPJ: [$cnpjUpper] ✗ Inválido")
            }
          } catch {
            case e: Exception =>
              System.err.println(s"[${index + 1}] Erro ao validar CNPJ [$cnpjUpper]: ${e.getMessage}")
          }
        }
      
      case "-dv" =>
        // Modo de cálculo de DV
        cnpjs.zipWithIndex.foreach { case (cnpj, index) =>
          val cnpjUpper = cnpj.toUpperCase
          
          try {
            val dv = CNPJ.calculaDV(cnpjUpper)
            println(s"[${index + 1}] CNPJ: [$cnpjUpper] DV: [$dv]")
            val cnpjSemMascara = CNPJ.removeMascaraCnpj(cnpjUpper)
            println(s"    CNPJ Completo: $cnpjSemMascara$dv")
          } catch {
            case e: Exception =>
              System.err.println(s"[${index + 1}] Erro ao calcular DV para CNPJ [$cnpjUpper]: ${e.getMessage}")
          }
        }
      
      case _ =>
        System.err.println(s"Erro: Operação desconhecida '$operacao'")
        printUsage()
        System.exit(1)
    }
  }

  /**
   * Exibe instruções de uso do programa
   */
  def printUsage(): Unit = {
    println("Uso:")
    println("  Para validar: scala Main.scala -v CNPJ1 [CNPJ2 CNPJ3 ...]")
    println("  Para calcular DV: scala Main.scala -dv CNPJ1 [CNPJ2 CNPJ3 ...]")
    println("\nExemplos:")
    println("  scala Main.scala -v 12ABC34501DE35")
    println("  scala Main.scala -dv 12ABC34501DE")
  }
}
