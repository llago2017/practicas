
var arguments = CommandLine.arguments
var testGame = MasterMindGame();
if !arguments.isEmpty {
    print(arguments)
    let Nargs = arguments.count
    switch Nargs {
    case 2:
        print("Numero de turnos: \(arguments[1])")
        testGame.maxTurns = Int(arguments[1])!
        break;
    case 3:
        print("Numero de turnos: \(arguments[1])")
        testGame.maxTurns = Int(arguments[1])!
        print("Numero de codigo: \(arguments[2])")
        //testGame.secretCode.count = Int(arguments[2])!
        
    default:
        print("Funcionamiento por defecto")
    }
} else {print("No hay argumentos")}


for _ in 0..<testGame.maxTurns {
    if testGame.currentTurn < testGame.maxTurns {
        print("Enter your guess: ")
        let guess = readLine()!
        testGame.newTurn(guess)
    }
    
    
}
