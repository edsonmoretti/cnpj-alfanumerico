use regex::Regex;
use std::error::Error;
use std::fmt;

const TAMANHO_CNPJ_SEM_DV: usize = 12;
const TAMANHO_CNPJ_COMPLETO: usize = 14;

// Pesos para cálculo do primeiro dígito verificador
const PESOS_DV1: [u8; 12] = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

// Pesos para cálculo do segundo dígito verificador
const PESOS_DV2: [u8; 13] = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

/// Erro customizado para operações de CNPJ
#[derive(Debug)]
pub struct CNPJError {
    message: String,
}

impl CNPJError {
    fn new(message: &str) -> Self {
        CNPJError {
            message: message.to_string(),
        }
    }
}

impl fmt::Display for CNPJError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Erro de CNPJ: {}", self.message)
    }
}

impl Error for CNPJError {}

/// Verifica se um CNPJ alfanumérico é válido
///
/// # Arguments
///
/// * `cnpj` - CNPJ a ser validado
///
/// # Returns
///
/// * `true` se o CNPJ for válido, `false` caso contrário
pub fn is_valid(cnpj: &str) -> bool {
    lazy_static! {
        static ref REGEX_CARACTERES_PERMITIDOS: Regex = Regex::new(r"^[A-Z\d./-]*$").unwrap();
        static ref REGEX_CNPJ: Regex = Regex::new(r"^([A-Z\d]){12}(\d){2}$").unwrap();
    }

    // Verifica se contém apenas caracteres permitidos
    if !REGEX_CARACTERES_PERMITIDOS.is_match(cnpj) {
        return false;
    }

    // Remove máscara e converte para maiúsculas
    let cnpj_sem_mascara = remover_mascara_cnpj(&cnpj.to_uppercase());
    
    // Verifica o tamanho do CNPJ sem máscara
    if cnpj_sem_mascara.len() != TAMANHO_CNPJ_COMPLETO {
        return false;
    }
    
    // Verifica se o CNPJ não contém apenas zeros
    if apenas_zeros(&cnpj_sem_mascara) {
        return false;
    }
    
    // Verifica se o CNPJ corresponde ao padrão correto
    if !REGEX_CNPJ.is_match(&cnpj_sem_mascara) {
        return false;
    }
    
    // Extrai os dígitos verificadores informados
    let dv_informado = &cnpj_sem_mascara[TAMANHO_CNPJ_SEM_DV..];
    
    // Calcula os dígitos verificadores
    match calcula_dv(&cnpj_sem_mascara[..TAMANHO_CNPJ_SEM_DV]) {
        Ok(dv_calculado) => dv_informado == dv_calculado,
        Err(_) => false,
    }
}

/// Calcula os dígitos verificadores de um CNPJ alfanumérico
///
/// # Arguments
///
/// * `cnpj` - Base do CNPJ (12 caracteres alfanuméricos)
///
/// # Returns
///
/// * `Result<String, CNPJError>` - Dígitos verificadores calculados ou erro
pub fn calcula_dv(cnpj: &str) -> Result<String, CNPJError> {
    lazy_static! {
        static ref REGEX_CARACTERES_PERMITIDOS: Regex = Regex::new(r"^[A-Z\d./-]*$").unwrap();
        static ref REGEX_CNPJ_SEM_DV: Regex = Regex::new(r"^([A-Z\d]){12}$").unwrap();
    }

    // Verifica se contém apenas caracteres permitidos
    if !REGEX_CARACTERES_PERMITIDOS.is_match(cnpj) {
        return Err(CNPJError::new("CNPJ contém caracteres não permitidos"));
    }
    
    // Remove máscara e converte para maiúsculas
    let cnpj_sem_mascara = remover_mascara_cnpj(&cnpj.to_uppercase());
    
    // Usa apenas os primeiros 12 caracteres
    let cnpj_base = if cnpj_sem_mascara.len() >= TAMANHO_CNPJ_SEM_DV {
        &cnpj_sem_mascara[..TAMANHO_CNPJ_SEM_DV]
    } else {
        &cnpj_sem_mascara
    };
    
    // Verifica o tamanho da base do CNPJ
    if cnpj_base.len() != TAMANHO_CNPJ_SEM_DV {
        return Err(CNPJError::new(&format!("CNPJ deve ter {} caracteres para calcular o DV", TAMANHO_CNPJ_SEM_DV)));
    }
    
    // Verifica se o CNPJ corresponde ao padrão correto
    if !REGEX_CNPJ_SEM_DV.is_match(cnpj_base) {
        return Err(CNPJError::new("CNPJ não está no formato correto"));
    }
    
    // Verifica se o CNPJ não contém apenas zeros
    if apenas_zeros(cnpj_base) {
        return Err(CNPJError::new("CNPJ não pode conter apenas zeros"));
    }
    
    // Calcula o primeiro dígito verificador
    let dv1 = calcular_digito(cnpj_base, &PESOS_DV1)?;
    
    // Adiciona o primeiro dígito verificador à base para calcular o segundo
    let cnpj_com_dv1 = format!("{}{}", cnpj_base, dv1);
    
    // Calcula o segundo dígito verificador
    let dv2 = calcular_digito(&cnpj_com_dv1, &PESOS_DV2)?;
    
    // Retorna os dígitos verificadores como string
    Ok(format!("{}{}", dv1, dv2))
}

/// Remove a máscara de formatação do CNPJ
///
/// # Arguments
///
/// * `cnpj` - CNPJ com máscara
///
/// # Returns
///
/// * `String` - CNPJ sem máscara
pub fn remover_mascara_cnpj(cnpj: &str) -> String {
    lazy_static! {
        static ref REGEX_CARACTERES_MASCARA: Regex = Regex::new(r"[./-]").unwrap();
    }
    REGEX_CARACTERES_MASCARA.replace_all(cnpj, "").to_string()
}

/// Converte um caractere alfanumérico para seu valor numérico
///
/// # Arguments
///
/// * `c` - Caractere a ser convertido
///
/// # Returns
///
/// * `Result<u8, CNPJError>` - Valor numérico do caractere ou erro
fn converter_caractere(c: char) -> Result<u8, CNPJError> {
    // Se for dígito, retorna seu valor numérico
    if c.is_digit(10) {
        return Ok(c.to_digit(10).unwrap() as u8);
    }
    // Se for letra maiúscula, retorna seu valor convertido
    else if c.is_ascii_uppercase() {
        return Ok((c as u8) - b'0' - 7); // 'A' (65) - '0' (48) - 7 = 10
    }
    // Caractere inválido
    Err(CNPJError::new(&format!("Caractere inválido: {}", c)))
}

/// Verifica se um CNPJ contém apenas zeros
///
/// # Arguments
///
/// * `cnpj` - CNPJ a ser verificado
///
/// # Returns
///
/// * `bool` - true se o CNPJ contiver apenas zeros, false caso contrário
fn apenas_zeros(cnpj: &str) -> bool {
    cnpj.chars().all(|c| c == '0')
}

/// Calcula um dígito verificador com base nos pesos fornecidos
///
/// # Arguments
///
/// * `cnpj` - CNPJ a ser usado no cálculo
/// * `pesos` - Pesos a serem aplicados
///
/// # Returns
///
/// * `Result<char, CNPJError>` - Dígito verificador calculado ou erro
fn calcular_digito(cnpj: &str, pesos: &[u8]) -> Result<char, CNPJError> {
    // Verifica se o tamanho do CNPJ é compatível com os pesos
    if cnpj.len() > pesos.len() {
        return Err(CNPJError::new("Tamanho do CNPJ incompatível com os pesos"));
    }
    
    let mut soma = 0;
    
    // Calcula a soma dos produtos
    for (i, c) in cnpj.chars().enumerate() {
        let valor = converter_caractere(c)?;
        soma += u32::from(valor) * u32::from(pesos[i]);
    }
    
    // Calcula o dígito verificador
    let resto = soma % 11;
    let dv = if resto < 2 {
        '0'
    } else {
        char::from_digit(11 - resto, 10).unwrap()
    };
    
    Ok(dv)
}

#[macro_use]
extern crate lazy_static;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_is_valid() {
        assert!(is_valid("12ABC34501DE35"));
        assert!(is_valid("12.ABC.345/01DE-35"));
        assert!(!is_valid("12ABC34501DE99"));
        assert!(!is_valid("00000000000000"));
        assert!(!is_valid("ABCDEFGHIJ0000"));
        assert!(!is_valid("@#$%^&*()_+"));
    }

    #[test]
    fn test_calcula_dv() {
        assert_eq!(calcula_dv("12ABC34501DE").unwrap(), "35");
        assert_eq!(calcula_dv("12.ABC.345/01DE").unwrap(), "35");
        assert!(calcula_dv("000000000000").is_err());
        assert!(calcula_dv("@#$%^&*()_+").is_err());
    }

    #[test]
    fn test_remover_mascara_cnpj() {
        assert_eq!(remover_mascara_cnpj("12.ABC.345/01DE-35"), "12ABC34501DE35");
        assert_eq!(remover_mascara_cnpj("12ABC34501DE35"), "12ABC34501DE35");
    }
}
