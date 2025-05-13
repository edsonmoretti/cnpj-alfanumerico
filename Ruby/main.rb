#!/usr/bin/env ruby

require_relative 'cnpj'

# Função para exibir instruções de uso
def print_usage
  puts "Uso:"
  puts "  Para validar: ruby main.rb -v CNPJ1 [CNPJ2 CNPJ3 ...]"
  puts "  Para calcular DV: ruby main.rb -dv CNPJ1 [CNPJ2 CNPJ3 ...]"
  puts "\nExemplos:"
  puts "  ruby main.rb -v 12ABC34501DE35"
  puts "  ruby main.rb -dv 12ABC34501DE"
end

# Verifica se foram passados argumentos suficientes
if ARGV.length < 2
  STDERR.puts "Erro: Argumentos insuficientes"
  print_usage
  exit 1
end

# Verifica a operação solicitada
operacao = ARGV[0].downcase
cnpjs = ARGV[1..-1]

case operacao
when "-v"
  # Modo de validação
  cnpjs.each_with_index do |cnpj, i|
    cnpj_upper = cnpj.upcase
    
    begin
      if CNPJ.valid?(cnpj_upper)
        puts "[#{i+1}] CNPJ: [#{cnpj_upper}] ✓ Válido"
      else
        puts "[#{i+1}] CNPJ: [#{cnpj_upper}] ✗ Inválido"
      end
    rescue => e
      STDERR.puts "[#{i+1}] Erro ao validar CNPJ [#{cnpj_upper}]: #{e.message}"
    end
  end
when "-dv"
  # Modo de cálculo de DV
  cnpjs.each_with_index do |cnpj, i|
    cnpj_upper = cnpj.upcase
    
    begin
      dv = CNPJ.calcular_dv(cnpj_upper)
      puts "[#{i+1}] CNPJ: [#{cnpj_upper}] DV: [#{dv}]"
      cnpj_sem_mascara = CNPJ.remover_mascara(cnpj_upper)
      puts "    CNPJ Completo: #{cnpj_sem_mascara}#{dv}"
    rescue => e
      STDERR.puts "[#{i+1}] Erro ao calcular DV para CNPJ [#{cnpj_upper}]: #{e.message}"
    end
  end
else
  STDERR.puts "Erro: Operação desconhecida '#{operacao}'"
  print_usage
  exit 1
end
