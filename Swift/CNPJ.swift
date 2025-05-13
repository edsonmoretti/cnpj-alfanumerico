import Foundation

class CNPJ {
    private static let cnpjBaseLengthWithoutDV = 12
    private static let cnpjBaseWithDVLength = 14
    private static let dv1Weights = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
    private static let dv2Weights = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
    
    private static let cnpjPattern = "^[A-Z0-9]{12}[0-9]{2}$"
    private static let cnpjWithoutDVPattern = "^[A-Z0-9]{12}$"
    private static let formatCharactersPattern = "[./-]"
    
    /// Verifica se um CNPJ alfanumérico é válido
    /// - Parameter cnpj: CNPJ a ser validado (com ou sem máscara)
    /// - Returns: true se o CNPJ for válido, false caso contrário
    static func isValid(_ cnpj: String) -> Bool {
        let cnpj = removeMask(from: cnpj.uppercased())
        
        // Verificar formato
        guard let regex = try? NSRegularExpression(pattern: cnpjPattern, options: []),
              regex.numberOfMatches(in: cnpj, options: [], range: NSRange(location: 0, length: cnpj.count)) > 0 else {
            return false
        }
        
        // Verificar se não é CNPJ zerado
        if cnpj == String(repeating: "0", count: cnpjBaseWithDVLength) {
            return false
        }
        
        // Obter base e DVs informados
        let base = String(cnpj.prefix(cnpjBaseLengthWithoutDV))
        let informedDV = String(cnpj.suffix(2))
        
        // Calcular DVs e comparar
        if let calculatedDV = try? calculateDV(base) {
            return informedDV == calculatedDV
        }
        
        return false
    }
    
    /// Calcula os dígitos verificadores para um CNPJ alfanumérico
    /// - Parameter cnpj: Base do CNPJ (12 caracteres alfanuméricos)
    /// - Returns: String contendo os 2 dígitos verificadores
    /// - Throws: Erro se o formato do CNPJ for inválido
    static func calculateDV(_ cnpj: String) throws -> String {
        let cnpj = removeMask(from: cnpj.uppercased())
        
        // Verificar formato
        guard let regex = try? NSRegularExpression(pattern: cnpjWithoutDVPattern, options: []),
              regex.numberOfMatches(in: cnpj, options: [], range: NSRange(location: 0, length: cnpj.count)) > 0 else {
            throw CNPJError.invalidFormat
        }
        
        // Verificar se não é CNPJ zerado
        if cnpj == String(repeating: "0", count: cnpjBaseLengthWithoutDV) {
            throw CNPJError.invalidCNPJ
        }
        
        // Calcular primeiro DV
        let dv1 = calculateDigit(cnpj, weights: dv1Weights)
        
        // Calcular segundo DV
        let dv2 = calculateDigit(cnpj + String(dv1), weights: dv2Weights)
        
        return "\(dv1)\(dv2)"
    }
    
    private static func calculateDigit(_ cnpj: String, weights: [Int]) -> Int {
        var sum = 0
        let cnpjValues = cnpjToValues(cnpj)
        
        for i in 0..<cnpjValues.count {
            let weightIndex = weights.count - cnpjValues.count + i
            sum += cnpjValues[i] * weights[weightIndex]
        }
        
        let remainder = sum % 11
        return remainder < 2 ? 0 : 11 - remainder
    }
    
    private static func cnpjToValues(_ cnpj: String) -> [Int] {
        return cnpj.map { char -> Int in
            let asciiValue = Int(char.asciiValue!)
            return asciiValue - 48
        }
    }
    
    private static func removeMask(from cnpj: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: formatCharactersPattern, options: []) else {
            return cnpj
        }
        
        return regex.stringByReplacingMatches(in: cnpj, options: [], range: NSRange(location: 0, length: cnpj.count), withTemplate: "")
    }
    
    enum CNPJError: Error {
        case invalidFormat
        case invalidCNPJ
    }
}
