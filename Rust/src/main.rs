use clap::{Parser, Subcommand};
use cnpj_alfanumerico::{calcula_dv, is_valid, remover_mascara_cnpj};

#[derive(Parser)]
#[command(author, version, about = "Validação e cálculo de DV para CNPJ alfanumérico")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Validar um CNPJ alfanumérico
    #[command(short_flag = 'v', visible_alias = "validar")]
    Validar {
        /// Lista de CNPJs para validar
        #[arg(required = true)]
        cnpjs: Vec<String>,
    },
    /// Calcular os dígitos verificadores de uma base de CNPJ
    #[command(short_flag = 'd', name = "dv", visible_alias = "calcular")]
    CalcularDV {
        /// Lista de bases de CNPJ para calcular os dígitos verificadores
        #[arg(required = true)]
        cnpjs: Vec<String>,
    },
}

fn main() {
    let cli = Cli::parse();

    match &cli.command {
        Commands::Validar { cnpjs } => {
            // Modo de validação
            for (i, cnpj) in cnpjs.iter().enumerate() {
                let cnpj_upper = cnpj.to_uppercase();
                
                if is_valid(&cnpj_upper) {
                    println!("[{}] CNPJ: [{}] ✓ Válido", i + 1, cnpj_upper);
                } else {
                    println!("[{}] CNPJ: [{}] ✗ Inválido", i + 1, cnpj_upper);
                }
            }
        }
        Commands::CalcularDV { cnpjs } => {
            // Modo de cálculo de DV
            for (i, cnpj) in cnpjs.iter().enumerate() {
                let cnpj_upper = cnpj.to_uppercase();
                
                match calcula_dv(&cnpj_upper) {
                    Ok(dv) => {
                        println!("[{}] CNPJ: [{}] DV: [{}]", i + 1, cnpj_upper, dv);
                        let cnpj_sem_mascara = remover_mascara_cnpj(&cnpj_upper);
                        println!("    CNPJ Completo: {}{}", cnpj_sem_mascara, dv);
                    }
                    Err(e) => {
                        eprintln!("[{}] Erro ao calcular DV para CNPJ [{}]: {}", i + 1, cnpj_upper, e);
                    }
                }
            }
        }
    }
}
