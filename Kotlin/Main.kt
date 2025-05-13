package com.edsonmoretti.cnpj

/**
 * Programa principal para validação e cálculo de DV de CNPJ alfanumérico
 */
fun main(args: Array<String>) {
    if (args.isEmpty()) {
        printUsage()
        return
    }

    // Verifica a operação solicitada
    val operacao = args[0].toLowerCase()
    
    if (args.size < 2) {
        System.err.println("Erro: Argumentos insuficientes")
        printUsage()
        System.exit(1)
    }

    // Lista de CNPJs (excluindo o primeiro argumento que é a operação)
    val cnpjs = args.drop(1)

    when (operacao) {
        "-v" -> {
            // Modo de validação
            cnpjs.forEachIndexed { index, cnpj ->
                val cnpjUpper = cnpj.toUpperCase()
                
                try {
                    if (CNPJ.isValid(cnpjUpper)) {
                        println("[${index + 1}] CNPJ: [$cnpjUpper] ✓ Válido")
                    } else {
                        println("[${index + 1}] CNPJ: [$cnpjUpper] ✗ Inválido")
                    }
                } catch (e: Exception) {
                    System.err.println("[${index + 1}] Erro ao validar CNPJ [$cnpjUpper]: ${e.message}")
                }
            }
        }
        "-dv" -> {
            // Modo de cálculo de DV
            cnpjs.forEachIndexed { index, cnpj ->
                val cnpjUpper = cnpj.toUpperCase()
                
                try {
                    val dv = CNPJ.calculaDV(cnpjUpper)
                    println("[${index + 1}] CNPJ: [$cnpjUpper] DV: [$dv]")
                    val cnpjSemMascara = CNPJ.removeMascaraCNPJ(cnpjUpper)
                    println("    CNPJ Completo: $cnpjSemMascara$dv")
                } catch (e: Exception) {
                    System.err.println("[${index + 1}] Erro ao calcular DV para CNPJ [$cnpjUpper]: ${e.message}")
                }
            }
        }
        else -> {
            System.err.println("Erro: Operação desconhecida '$operacao'")
            printUsage()
            System.exit(1)
        }
    }
}

/**
 * Exibe instruções de uso do programa
 */
fun printUsage() {
    println("Uso:")
    println("  Para validar: kotlin Main.kt -v CNPJ1 [CNPJ2 CNPJ3 ...]")
    println("  Para calcular DV: kotlin Main.kt -dv CNPJ1 [CNPJ2 CNPJ3 ...]")
    println("\nExemplos:")
    println("  kotlin Main.kt -v 12ABC34501DE35")
    println("  kotlin Main.kt -dv 12ABC34501DE")
}
