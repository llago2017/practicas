import Socket
import Glibc

let message = "Hello, world!"

var arguments = CommandLine.arguments
if !arguments.isEmpty {
    if arguments.count > 1 {
        let server = arguments[1]
        let port = Int32(arguments[2])!
    }

    do {
        guard let serverAddress = Socket.createAddress(for: arguments[1], on: Int32(arguments[2])!) else {
            print("Error creating Address")
            exit(1)
        }

        let clientSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
        try clientSocket.write(from: message, to: serverAddress)
    } catch let error {
        print("Connection error: \(error)")
    }
    
}



