//
//  ChatServer.swift
//

import Foundation
import Socket
import ChatMessage

enum ChatServerError: Error {
    /**
     Thrown on communications error.
     Initialize with the underlying Error thrown by the Socket library.
     */
    case networkError(socketError: Error)
    
    /**
     Thrown if an unexpected message or argument is received.
     For example, the server should never receive a 'Server' message.
     */
    case protocolError
}


class ChatServer {
    let port: Int
    var serverSocket: Socket
    
    var readers = ClientCollectionArray(uniqueNicks: false)
    var writers = ClientCollectionArray(uniqueNicks: true)
    
    init(port: Int) throws {
        self.port = port
        serverSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
    }
    
    func run() throws {
        do {
            // Your code here
            try serverSocket.listen(on: port)
            // Mensajes que aparecen en consola
            print("Listening on \(port)")
            // Reservo espacio en memoria para leer los mensajes que llegan
            var buffer = Data(capacity: 1000) 
            repeat {
                let (bytesRead, clientAddress) = try serverSocket.readDatagram(into: &buffer)
                // Cuando se conecta uno me dice la dirección y los bytes que envía
                if let address = clientAddress {
                    let (clientHostname, clientPort) = Socket.hostnameAndPort(from: address)!

                    
                    print("Received length \(bytesRead) from \(clientHostname):\(clientPort)")
                    let message = String(decoding: buffer, as: UTF8.self)
                    print("Message: \(message)")
                    try serverSocket.write(from: message, to: clientAddress!)
                }
                buffer.removeAll()
            } while true
        } catch let error {
            throw ChatServerError.networkError(socketError: error)
        }
    }
}

// Add additional functions using extensions