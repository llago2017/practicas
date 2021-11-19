import Foundation

// Read command-line argumens
let server: String
let port: Int
let mode: String

var arguments = CommandLine.arguments
print(arguments)

if !arguments.isEmpty {
    if arguments.count != 4 {
        server = String(arguments[1])
        port = Int(arguments[2])!
        mode = String(arguments[3])
        print("Servidor: \(server), puerto: \(port), usuario: \(mode)")
    } else {
        print("Inicia el cliente: run chat-client <Nombre del servidor> <Puerto> <Nombre>")
        
    }

    
    
}





// Create ChatClient

// Run ChatClient
