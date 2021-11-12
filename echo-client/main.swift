import Socket
import Glibc
import Foundation

let message = "Hello, world!"

var arguments = CommandLine.arguments
if !arguments.isEmpty {
    if arguments.count != 3 {
        print("Inicie con: swift run <echo-client> <server-name> <port>")
        
    } else {
        let server = arguments[1]
        let port = Int32(arguments[2])!

         do {
            guard let serverAddress = Socket.createAddress(for: server, on: port) else {
                print("Error creating Address")
                exit(1)
            }

            let clientSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
            try clientSocket.write(from: message, to: serverAddress)
            
            // Leo mensaje
            var buffer = Data(capacity: 1000)
            try clientSocket.readDatagram(into: &buffer)
            let server_string = String(decoding: buffer, as: UTF8.self)
            print("> Server: " + server_string)
            
        } catch let error {
            print("Connection error: \(error)")
        }
        
    }

   
    
}



