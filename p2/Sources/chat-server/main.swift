import Foundation

var arguments = CommandLine.arguments
// Read command-line argumens
if !arguments.isEmpty {
    if arguments.count == 3 {

        
            // Create ChatClient
            do {
                let port = Int(arguments[1])
                let maxCapacity = Int(arguments[2])
                if port == nil || maxCapacity == nil {
                    throw ChatServerError.protocolError   
                }
                
                let MyServer = try ChatServer(port: port!, maxCapacity: maxCapacity!)
                 do {
                    try MyServer.run()
                } catch let error {
                    print("Error: ", error)
                }
            } catch let error {
                print(error, " Mensaje o argumento inesperado", separator: ":")
                print("Inicia el servidor: run chat-server <Puerto> <Max. Clientes>")
                print("Numero Max. Clientes entre 2 y 50")
                exit(1)
            }
            
            
           
            
        //print("Puerto: \(port)")

        
        

    } else {
        print("Inicia el servidor: run chat-server <Puerto> <Max. Clientes>")
        
    }

}