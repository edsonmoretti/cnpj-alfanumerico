import 'dart:io';
import 'cnpj.dart';

void printUsage() {
  print('Uso:');
  print('  Para validar: dart main.dart -v CNPJ1 [CNPJ2 CNPJ3 ...]');
  print('  Para calcular DV: dart main.dart -dv CNPJ1 [CNPJ2 CNPJ3 ...]');
  print('\nExemplos:');
  print('  dart main.dart -v 12ABC34501DE35');
  print('  dart main.dart -dv 12ABC34501DE');
}

void main(List<String> args) {
  if (args.length < 2) {
    stderr.writeln('Erro: Argumentos insuficientes');
    printUsage();
    exit(1);
  }

  // Verifica a operação solicitada
  String operacao = args[0].toLowerCase();
  
  // Remove a operação da lista de argumentos
  List<String> cnpjs = args.sublist(1);

  if (operacao == '-v') {
    // Modo de validação
    for (int i = 0; i < cnpjs.length; i++) {
      String cnpjStr = cnpjs[i].toUpperCase();
      
      try {
        if (CNPJ.isValid(cnpjStr)) {
          print('[${i + 1}] CNPJ: [$cnpjStr] ✓ Válido');
        } else {
          print('[${i + 1}] CNPJ: [$cnpjStr] ✗ Inválido');
        }
      } catch (e) {
        stderr.writeln('[${i + 1}] Erro ao validar CNPJ [$cnpjStr]: $e');
      }
    }
  } else if (operacao == '-dv') {
    // Modo de cálculo de DV
    for (int i = 0; i < cnpjs.length; i++) {
      String cnpjStr = cnpjs[i].toUpperCase();
      
      try {
        String dv = CNPJ.calculaDV(cnpjStr);
        print('[${i + 1}] CNPJ: [$cnpjStr] DV: [$dv]');
        String cnpjSemMascara = CNPJ.removeMascaraCnpj(cnpjStr);
        print('    CNPJ Completo: $cnpjSemMascara$dv');
      } catch (e) {
        stderr.writeln('[${i + 1}] Erro ao calcular DV para CNPJ [$cnpjStr]: $e');
      }
    }
  } else {
    stderr.writeln('Erro: Operação desconhecida \'$operacao\'');
    printUsage();
    exit(1);
  }
}
