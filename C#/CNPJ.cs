using System;
using System.Linq;
using System.Text.RegularExpressions;

namespace CNPJAlfanumerico
{
    public class CNPJ
    {
        private const int TamanhoCnpjSemDv = 12;
        private const int TamanhoCnpjCompleto = 14;
        
        private static readonly Regex RegexCnpj = new Regex(@"^([A-Z\d]){12}(\d){2}$", RegexOptions.Compiled);
        private static readonly Regex RegexCnpjSemDv = new Regex(@"^([A-Z\d]){12}$", RegexOptions.Compiled);
        private static readonly Regex RegexCaracteresMascara = new Regex(@"[./-]", RegexOptions.Compiled);
        private static readonly Regex RegexCaracteresPermitidos = new Regex(@"^[A-Z\d./-]*$", RegexOptions.Compiled);
        
        private static readonly int[] PesosDv1 = { 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2 };
        private static readonly int[] PesosDv2 = { 6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2 };
        
        /// <summary>
        /// Verifica se um CNPJ alfanumérico é válido
        /// </summary>
        /// <param name="cnpj">O CNPJ a ser validado</param>
        /// <returns>true se o CNPJ for válido, false caso contrário</returns>
        public static bool IsValid(string cnpj)
        {
            if (string.IsNullOrWhiteSpace(cnpj) || !RegexCaracteresPermitidos.IsMatch(cnpj))
            {
                return false;
            }

            var cnpjSemMascara = RemoveMascaraCnpj(cnpj.ToUpper());
            
            // Verifica o tamanho do CNPJ sem máscara
            if (cnpjSemMascara.Length != TamanhoCnpjCompleto)
            {
                return false;
            }
            
            // Verifica se o CNPJ não contém apenas zeros
            if (ApenasZeros(cnpjSemMascara))
            {
                return false;
            }
            
            // Verifica se o CNPJ corresponde ao padrão correto
            if (!RegexCnpj.IsMatch(cnpjSemMascara))
            {
                return false;
            }
            
            // Extrai os dígitos verificadores informados
            var dvInformado = cnpjSemMascara.Substring(TamanhoCnpjSemDv, 2);
            
            // Calcula os dígitos verificadores
            var dvCalculado = CalculaDV(cnpjSemMascara.Substring(0, TamanhoCnpjSemDv));
            
            // Compara os dígitos verificadores
            return dvInformado == dvCalculado;
        }

        /// <summary>
        /// Calcula os dígitos verificadores de um CNPJ alfanumérico
        /// </summary>
        /// <param name="cnpj">A base do CNPJ (12 caracteres alfanuméricos)</param>
        /// <returns>Os dígitos verificadores calculados ou null em caso de erro</returns>
        public static string CalculaDV(string cnpj)
        {
            if (string.IsNullOrWhiteSpace(cnpj) || !RegexCaracteresPermitidos.IsMatch(cnpj))
            {
                throw new ArgumentException("CNPJ contém caracteres não permitidos.", nameof(cnpj));
            }
            
            var cnpjSemMascara = RemoveMascaraCnpj(cnpj.ToUpper());
            
            // Usa apenas os primeiros 12 caracteres
            if (cnpjSemMascara.Length >= TamanhoCnpjSemDv)
            {
                cnpjSemMascara = cnpjSemMascara.Substring(0, TamanhoCnpjSemDv);
            }
            
            // Verifica o tamanho da base do CNPJ
            if (cnpjSemMascara.Length != TamanhoCnpjSemDv)
            {
                throw new ArgumentException($"CNPJ deve ter {TamanhoCnpjSemDv} caracteres para calcular o DV.", nameof(cnpj));
            }
            
            // Verifica se o CNPJ corresponde ao padrão correto
            if (!RegexCnpjSemDv.IsMatch(cnpjSemMascara))
            {
                throw new ArgumentException("CNPJ não está no formato correto.", nameof(cnpj));
            }
            
            // Verifica se o CNPJ não contém apenas zeros
            if (ApenasZeros(cnpjSemMascara))
            {
                throw new ArgumentException("CNPJ não pode conter apenas zeros.", nameof(cnpj));
            }
            
            // Calcula o primeiro dígito verificador
            int dv1 = CalcularDigito(cnpjSemMascara, PesosDv1);
            if (dv1 < 0)
            {
                throw new InvalidOperationException("Erro ao calcular o primeiro dígito verificador.");
            }
            
            // Adiciona o primeiro dígito verificador à base para calcular o segundo
            string cnpjComDv1 = cnpjSemMascara + dv1;
            
            // Calcula o segundo dígito verificador
            int dv2 = CalcularDigito(cnpjComDv1, PesosDv2);
            if (dv2 < 0)
            {
                throw new InvalidOperationException("Erro ao calcular o segundo dígito verificador.");
            }
            
            // Retorna os dígitos verificadores como string
            return $"{dv1}{dv2}";
        }

        /// <summary>
        /// Remove a máscara de formatação do CNPJ
        /// </summary>
        /// <param name="cnpj">O CNPJ com máscara</param>
        /// <returns>O CNPJ sem máscara</returns>
        public static string RemoveMascaraCnpj(string cnpj)
        {
            return RegexCaracteresMascara.Replace(cnpj, "");
        }

        /// <summary>
        /// Converte um caractere alfanumérico para seu valor numérico
        /// </summary>
        /// <param name="c">O caractere a ser convertido</param>
        /// <returns>O valor numérico do caractere, ou -1 em caso de erro</returns>
        private static int ConverterCaractere(char c)
        {
            // Se for dígito, retorna seu valor numérico
            if (char.IsDigit(c))
            {
                return c - '0';
            }
            // Se for letra maiúscula, retorna seu valor convertido (A=10, B=11, etc.)
            else if (char.IsUpper(c))
            {
                return (c - '0') - 7; // 'A' (65) - '0' (48) - 7 = 10
            }
            // Caractere inválido
            return -1;
        }

        /// <summary>
        /// Verifica se um CNPJ contém apenas zeros
        /// </summary>
        /// <param name="cnpj">O CNPJ a ser verificado</param>
        /// <returns>true se o CNPJ contiver apenas zeros, false caso contrário</returns>
        private static bool ApenasZeros(string cnpj)
        {
            return cnpj.All(c => c == '0');
        }

        /// <summary>
        /// Calcula um dígito verificador com base nos pesos fornecidos
        /// </summary>
        /// <param name="cnpj">O CNPJ a ser usado no cálculo</param>
        /// <param name="pesos">Os pesos a serem aplicados</param>
        /// <returns>O dígito verificador calculado, ou -1 em caso de erro</returns>
        private static int CalcularDigito(string cnpj, int[] pesos)
        {
            int soma = 0;
            
            // Verifica se o tamanho do CNPJ é compatível com os pesos
            if (cnpj.Length > pesos.Length)
            {
                return -1;
            }
            
            // Calcula a soma dos produtos
            for (int i = 0; i < cnpj.Length; i++)
            {
                int valor = ConverterCaractere(cnpj[i]);
                if (valor < 0)
                {
                    return -1; // Caractere inválido
                }
                soma += valor * pesos[i];
            }
            
            // Calcula o dígito verificador
            int resto = soma % 11;
            if (resto < 2)
            {
                return 0;
            }
            else
            {
                return 11 - resto;
            }
        }
    }
}
