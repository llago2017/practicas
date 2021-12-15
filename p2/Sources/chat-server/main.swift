import Foundation

var arguments = CommandLine.arguments
// Read command-line argumens
if !arguments.isEmpty {
    if arguments.count == 2 {

        let port = Int(arguments[1])

        if port == nil {
            print("El puerto no es correcto")
            exit(1)
            
        }
        //print("Puerto: \(port)")

        // Create ChatClient
        let MyServer = try! ChatServer(port: port!)
        
        do {
            
            try MyServer.run()
        } catch {
            print("Error")
        }
        

    } else {
        print("Inicia el servidor: run chat-server <Puerto>")
        
    }

}