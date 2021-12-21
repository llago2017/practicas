import Foundation

var arguments = CommandLine.arguments
// Read command-line argumens
if !arguments.isEmpty {
    if arguments.count == 3 {

        let port = Int(arguments[1])
        let maxCapacity = Int(arguments[2])

        if port == nil || maxCapacity == nil {
            print("Argumentos incorrectos")
            exit(1)
            
        }
        //print("Puerto: \(port)")

        // Create ChatClient
        let MyServer = try! ChatServer(port: port!, maxCapacity: maxCapacity!)
        
        do {
            
            try MyServer.run()
        } catch {
            print("Error")
        }
        

    } else {
        print("Inicia el servidor: run chat-server <Puerto> <Max. Clientes>")
        
    }

}