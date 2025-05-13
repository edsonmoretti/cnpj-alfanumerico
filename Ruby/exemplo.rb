#!/usr/bin/env ruby

require_relative 'cnpj'

# Exemplo 1: Validação de CNPJ
def teste_validacao
  # CNPJ válido
  cnpj_valido = "12ABC34501DE35"
  resultado = CNPJ.valid?(cnpj_valido)
  puts "CNPJ #{cnpj_valido} é #{resultado ? 'válido' : 'inválido'}"
  
  # CNPJ inválido
  cnpj_invalido = "12ABC34501DE99"
  resultado = CNPJ.valid?(cnpj_invalido)
  puts "CNPJ #{cnpj_invalido} é #{resultado ? 'válido' : 'inválido'}"
  
  # CNPJ com máscara
  cnpj_com_mascara = "12.ABC.345/01DE-35"
  resultado = CNPJ.valid?(cnpj_com_mascara)
  puts "CNPJ #{cnpj_com_mascara} é #{resultado ? 'válido' : 'inválido'}"
end

# Exemplo 2: Cálculo de DV
def teste_calculo_dv
  # CNPJ base
  cnpj_base = "12ABC34501DE"
  dv = CNPJ.calcular_dv(cnpj_base)
  puts "CNPJ Base: #{cnpj_base}"
  puts "Dígitos Verificadores: #{dv}"
  puts "CNPJ Completo: #{cnpj_base}#{dv}"
  
  # CNPJ base com máscara
  cnpj_base_mascara = "12.ABC.345/01DE"
  dv = CNPJ.calcular_dv(cnpj_base_mascara)
  puts "CNPJ Base: #{cnpj_base_mascara}"
  puts "Dígitos Verificadores: #{dv}"
  puts "CNPJ Completo: #{CNPJ.remover_mascara(cnpj_base_mascara)}#{dv}"
end

# Executar os testes
puts "== Testes de Validação =="
teste_validacao

puts "\n== Testes de Cálculo de DV =="
teste_calculo_dv
