//Lorena Lago Jaime

enum MasterMindColor {
    case red
    case green
    case yellow
    case blue
    case black
    case white
}


extension MasterMindColor {
    var emoji: String {
        switch self {
            case .red   : return "🔴"
            case .green : return "🟢"
            case .yellow: return "🟡"
            case .blue  : return "🔵"
            case .black : return "⚫"
            case .white : return "⚪"
        }
    }
}


enum MasterMindError: Error {
    case wrongCharacter    // The user supplied a wrong Character to `from`
}

extension MasterMindColor {
    static func from(emoji: Character) throws -> MasterMindColor {        
        switch emoji {
            case "🔴": return .red
            case "🟢": return .green
            case "🟡": return .yellow
            case "🔵": return .blue
            case "⚫": return .black
            case "⚪": return .white
            default: throw MasterMindError.wrongCharacter
        }
    }
}


extension MasterMindColor: CustomStringConvertible {
    public var description: String { return emoji }
}

// Ejercicio 1
extension MasterMindColor {
    static func from(letter: Character) throws -> MasterMindColor {        
        // Your code here
        switch (letter.uppercased()) {
           
            case "R": return .red
            case "B": return .blue
            case "G": return .green
            case "Y": return .yellow
            case "K": return .black
            case "W": return .white
            
            default:
                let emoji = try? MasterMindColor.from(emoji: letter)

                if let emoji = emoji {
                    return emoji
                }
            
                throw MasterMindError.wrongCharacter
        }
    }
}


extension String {
    func toMasterMindColorCombination() throws -> [MasterMindColor] {
        return try self.map { try MasterMindColor.from(letter: $0) }
    }
}

// Ejercicio 2

struct MasterMindGame {
    private let secretCode: [MasterMindColor]
    
    var maxTurns = 10
    var currentTurn = 0
    var Ncomb = 4
    
    static func randomCode(colors: Int) -> [MasterMindColor] {
       var combinacion = String()
       let opciones = ["r","g","b","y","w","k"]
       for _ in 0...colors {
            let random_color = opciones.randomElement()
            combinacion += random_color!
       }
        
        return try! combinacion.toMasterMindColorCombination()
    }
    
    init(_ secretCode: String? = nil) {
        if (secretCode == nil) {
           self.secretCode = MasterMindGame.randomCode(colors: self.Ncomb)
        } else {
            
            do {
                self.secretCode = try secretCode!.toMasterMindColorCombination()
            } catch {
                self.secretCode = MasterMindGame.randomCode(colors: 4)
            }

        }
    }
}

//Ejercicio 3
extension MasterMindGame {
    func countExactMatches (_ code:[MasterMindColor]) -> Int {
        var aciertos: Int = 0
        
        for i in 0...(Ncomb - 1) {
            if (self.secretCode[i] == code[i]) {
                aciertos += 1
            }
        }
        
        return aciertos
    }
}


// Ejercicio 4
extension MasterMindGame {
    func countPartialMatches (_ code:[MasterMindColor]) -> Int {
        var aciertos: Int = 0
        
        //Comprueba si el color está
        var secretcode = self.secretCode
        for color in code {
            if (secretcode.contains(color)) {
                // Voy comprobando color a color y elimino del código secreto si está para seguir buscando
                aciertos += 1
                if let i = secretcode.firstIndex(of: color) {
                    secretcode.remove(at: i) 
                }
            } 
        }
            
        
        let matches = self.countExactMatches(code)
        return aciertos - matches
    }
}

// Ejercicio 5
extension MasterMindGame {
    mutating func newTurn(_ guess: String) {
        // Your code here
        //var turno: Int = 0
        do {
            let userComb = try guess.toMasterMindColorCombination()
            
            // Compruebo si tiene el número correcto, son 4 números
            //let userMax = userComb.endIndex - 1
            print(self.secretCode.count)
            
            if (self.Ncomb != (self.secretCode.count)) {
                // número de colores incorrecto
                print("Debes hacer una apuesta con \(Ncomb) colores. Por favor, prueba de nuevo.")
            } else {
                // Compruebo si no estoy en el último turno o ha acertado
                if (self.currentTurn < self.maxTurns){
                    self.currentTurn += 1
                    print("Turno \(self.currentTurn).")
                    print("Tu combinación: \(userComb)")
                    // Cuento los aciertos
                    let aciertos = self.countExactMatches(userComb)
                    
                    // Si se aciertan todas termina el juego
                    if (self.secretCode == userComb) {
                        print("Has ganado en el turno \(self.currentTurn)")
                        // Paso el turno al final para completar
                        self.currentTurn = Int.max
                    } else {
                        // Semiaciertos
                        let semiaciertos =  self.countPartialMatches(userComb)

                        print("Aciertos: \(aciertos)")
                        print("Semiaciertos: \(semiaciertos)")
                        
                    }
                    
                } else {
                    if self.currentTurn != Int.max {
                        print("Lo siento, has perdido. Otra vez será.")
                    }
                    print("El juego ha terminado.")
                }
            }
    
        } catch {
            print("Combinación incorrecta. Por favor, prueba de nuevo.")
        }
    }
}