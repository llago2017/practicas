import Foundation

// Read command-line argumens
let host: String
let port: Int
let nick: String

var arguments = CommandLine.arguments

if !arguments.isEmpty {
    if arguments.count == 4 {
        host = String(arguments[1])
        port = Int(arguments[2])!
        nick = String(arguments[3])
        print("Servidor: \(host), puerto: \(port), usuario: \(nick)")
        // Create ChatClient
        let MyClient = ChatClient(host: host, port: port, nick: nick)
        do {
            try MyClient.run()
        } catch {
            print("Error")
            
        }
        

    } else {
        print("Inicia el cliente: run chat-client <Nombre del servidor> <Puerto> <Nombre>")
        
    }

}

// Run ChatClient
