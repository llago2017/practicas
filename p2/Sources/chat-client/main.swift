import Foundation

// Read command-line arguments
let host: String
let port: Int
let nick: String

var arguments = CommandLine.arguments

if !arguments.isEmpty {
    if arguments.count == 4 {
        host = String(arguments[1])
        port = Int(arguments[2])!
        nick = String(arguments[3])

        // Create ChatClient
        if nick != "server" {
            let MyClient = ChatClient(host: host, port: port, nick: nick)
            do {
                // Run ChatClient
                try MyClient.run()
            } catch {
                print("Error")
            }
            
        } else {
            print("Invalid nickname")
            
        }
        
        

    } else {
        print("Inicia el cliente: run chat-client <Nombre del servidor> <Puerto> <Nombre>")
        
    }

}
