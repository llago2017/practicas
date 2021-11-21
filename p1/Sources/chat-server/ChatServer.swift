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

            print("Listening on \(port)")
            
            var buffer = Data(capacity: 1000)
            var client_nicks = [String]()
            var found = false;
            repeat {
                let (bytesRead, clientAddress) = try serverSocket.readDatagram(into: &buffer)
                // Cuando se conecta uno me dice la dirección y los bytes que envía
                if let address = clientAddress {
                    let (clientHostname, clientPort) = Socket.hostnameAndPort(from: address)!

                    //print("Received length \(bytesRead) from \(clientHostname):\(clientPort)")

                    
                   let value = buffer.withUnsafeBytes {
                        $0.load(as: ChatMessage.self)
                    }
                    //print("String: \(value)")
                    let msg = String(decoding: buffer, as: UTF8.self)

                    switch value {
                    case .Init:
                        var isReader: Bool { return msg == "reader" }

                        if isReader {
                            print("INIT received from \(msg)")
                            try! readers.addClient(address: clientAddress!, nick: msg)
                        } else {

                            do {
                                try writers.addClient(address: clientAddress!, nick: msg)
                                print("INIT received from \(msg)")
                            } catch {
                                print("INIT received from \(msg). IGNORED, nick already used")
                            }
                            
                            
                            /*let usedClient = writers.searchNick(nick: msg)
                            
                            if usedClient == nil {
                               print("INIT received from \(msg)")
                               try! writers.addClient(address: clientAddress!, nick: msg)
                               client_nicks.append(msg)
                            } else {
                               print("INIT received from \(msg). IGNORED, nick already used") 
                            }*/
                                    
                        }
                            

                        break;
                    
                    case .Writer:
                         let Wnick = writers.searchClient(address:clientAddress!)
                         if Wnick != nil {
                           print("WRITER received from \(Wnick!): \(msg)")  
                         }
                         
                        
                        
                    default:
                        print("En proceso")
                        
                        
                    }
                    
                    
                    //print("Mensaje: \(msg)")
                    
                    
                    //let message = String(decoding: buffer, as: UTF8.self)
                    //print("Message: \(message)")
                    //try serverSocket.write(from: message, to: clientAddress!)
                }
                buffer.removeAll()
            } while true
        } catch let error {
            throw ChatServerError.networkError(socketError: error)
        }
    }
}

// Add additional functions using extensions
