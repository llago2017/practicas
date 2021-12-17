//
//  ChatServer.swift
//

import Foundation
import Socket
import ChatMessage
import Collections

// Your code here

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

struct Client {
        var nickname: String
        var addres: Socket.Address
        var timestamp: Date
}

struct InactiveClient {
    var nickname: String
    var timestamp: Date
}

class ChatServer {
    let port: Int
    var serverSocket: Socket
    
    

    //var activeCLientrs = ArrayQueue<Client>
    //var InactiveClient = ArrayStack<InactiveClient>
    
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
            let queue = DispatchQueue.global() // Envío trabajos que ejecuta en paralelo
            var value = ChatMessage.Init

            queue.async {
                do {
                    repeat {
                    let (_, clientAddress) = try self.serverSocket.readDatagram(into: &buffer)
                    // Cuando se conecta uno me dice la dirección y los bytes que envía
                    if clientAddress != nil {
                        
                        //print("Received length \(bytesRead) from \(clientHostname):\(clientPort)")
                        var readBuffer = buffer
                                
                        
                        let count = MemoryLayout<ChatMessage>.size
                        var copyBytes = withUnsafeMutableBytes(of: &value) {
                            readBuffer.copyBytes(to: $0, from: 0..<count)
                        }
                    }

                    switch value {
                    case ChatMessage.Init:
                        print("Mensaje init")
                            var sendBuffer = Data(capacity: 1000)
                            
                            withUnsafeBytes(of: ChatMessage.Welcome) { sendBuffer.append(contentsOf: $0) }
                            withUnsafeBytes(of: true) { sendBuffer.append(contentsOf: $0) }
                                                                    
                            do {
                                let fechaDeAhora = Date()

                                var newClient = Client(nickname: "test", addres: clientAddress!, timestamp: fechaDeAhora )
                                
                                var activeClients = ArrayQueue<Client>()
                                try activeClients.enqueue(newClient)

                                try self.serverSocket.write(from: sendBuffer, to: clientAddress!)
                                sendBuffer.removeAll()
                            } catch {
                                print("Error")                    
                            }
                            break;
                        default:
                            print("Cualquier cosa")
                            break;
                            
                            
                        }
                } while true
                } catch  {
                    print("Error leyendo mensaje")
                    
                }
                
            }
                      

            repeat {   
                let message = readLine()
                switch message {
                case "q":
                    exit(1)
                    break;
                case "Q":
                    exit(1)
                    break;
                    
                default:            
                    print("Enter 'q' (+ Enter) to quit.")
                }
   
            } while true
            
                
         
        } catch let error {
            throw ChatServerError.networkError(socketError: error)
        }
    }

}