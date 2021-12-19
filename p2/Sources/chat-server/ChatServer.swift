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

        func printClients(client: Client) {
                                                
                let port = Socket.hostnameAndPort(from: client.addres)!.port
                let addr = Socket.hostnameAndPort(from: client.addres)!.hostname 

                let df = DateFormatter()
                df.dateFormat = "yy-MMM-dd HH:mm"                     
                        
                print("\(client.nickname) (\(addr):\(port)): \(df.string(from: client.timestamp))")
        }

        do {
            // Your code here
            try serverSocket.listen(on: port)

            print("Listening on \(port)")
                    
            var buffer = Data(capacity: 1000)
            let queue = DispatchQueue.global() // Envío trabajos que ejecuta en paralelo
            var value = ChatMessage.Init
            var activeClients = ArrayQueue<Client>(maxCapacity: 3)
            var inactiveClients = ArrayStack<Client>()

            queue.async {
                do {
                    repeat {
                        let (_, clientAddress) = try self.serverSocket.readDatagram(into: &buffer)
                        // Cuando se conecta uno me dice la dirección y los bytes que envía
                        if clientAddress != nil {
                            
                            //print("Received length \(bytesRead) from \(clientHostname):\(clientPort)")
                            var readBuffer = buffer
                                    
                            
                            var count = MemoryLayout<ChatMessage>.size
                            var copyBytes = withUnsafeMutableBytes(of: &value) {
                                readBuffer.copyBytes(to: $0, from: 0..<count)
                            }

                            readBuffer = readBuffer.advanced(by:count)

                            var nickname = buffer.advanced(by: count).withUnsafeBytes {
                                    String(cString: $0.bindMemory(to: UInt8.self).baseAddress!)
                            }
                        

                            switch value {
                                case ChatMessage.Init:
                                    //print("Mensaje init")

                                    buffer.removeAll()
                                    readBuffer.removeAll()
                                    var sendBuffer = Data(capacity: 1000)
                                    
                                                                            
                                    do {
                                        let fechaDeAhora = Date()

                                        var newClient = Client(nickname: nickname, addres: clientAddress!, timestamp: fechaDeAhora )
                                        
                                        //print(nickname)
                                        
                                        var contains = activeClients.contains{ $0.nickname == newClient.nickname }
                                        //var ayuda = activeClients.contains(where: {$0.nickname == newClient.nickname})
                                        //print(contains)
                                        
                                        if contains {  
                                            print("INIT received form \(nickname): IGNORED. Nick already used")
                                                                            
                                            withUnsafeBytes(of: ChatMessage.Welcome) { sendBuffer.append(contentsOf: $0) }
                                            withUnsafeBytes(of: false) { sendBuffer.append(contentsOf: $0) }
                                            try self.serverSocket.write(from: sendBuffer, to: clientAddress!)
                                            sendBuffer.removeAll()
                                            
                                        } else {
                                            print("INIT received form \(nickname): ACCEPTED")
                                            
                                            withUnsafeBytes(of: ChatMessage.Welcome) { sendBuffer.append(contentsOf: $0) }
                                            withUnsafeBytes(of: true) { sendBuffer.append(contentsOf: $0) }
                                        
                                            try activeClients.enqueue(newClient)
                                            try self.serverSocket.write(from: sendBuffer, to: clientAddress!)
                                            sendBuffer.removeAll()

                                            func sendAll(client: Client) {
                                                // Envio el mensaje
                                                
                                                var sendBuffer = Data(capacity: 1000)
                                                withUnsafeBytes(of: ChatMessage.Server) { sendBuffer.append(contentsOf: $0) }
                                                
                                                "server".utf8CString.withUnsafeBytes { sendBuffer.append(contentsOf: $0) }
                                                "\(nickname) joins the chat".utf8CString.withUnsafeBytes { sendBuffer.append(contentsOf: $0) }
                                                                                
                                                do {
                                                    if client.addres != clientAddress! {
                                                        try self.serverSocket.write(from: sendBuffer, to: client.addres)
                                                    }
                                                    
                                                    sendBuffer.removeAll()
                                                } catch {
                                                    print("Error")
                                                    
                                                }
                                            }

                                            activeClients.forEach(sendAll)
                                        }
                                        
                                        
                                    } catch CollectionsError.maxCapacityReached {
                                        // Primero
                                        var first = activeClients.findFirst{$0 != nil}
                                        // Mando mensaje
                                        func sendAll(client: Client) {
                                            // Envio el mensaje
                                                
                                            var sendBuffer = Data(capacity: 1000)
                                            withUnsafeBytes(of: ChatMessage.Server) { sendBuffer.append(contentsOf: $0) }
                                                
                                            "server".utf8CString.withUnsafeBytes { sendBuffer.append(contentsOf: $0) }
                                            "\(first!.nickname) banned for being idle too long".utf8CString.withUnsafeBytes { sendBuffer.append(contentsOf: $0) }
                                                                                
                                            do {
                                                if client.addres != clientAddress! {
                                                    try self.serverSocket.write(from: sendBuffer, to: client.addres)
                                                }
                                                    
                                                sendBuffer.removeAll()
                                            } catch {
                                                print("Error")
                                                    
                                            }
                                        }
                                        activeClients.forEach(sendAll)
                                        
                                        // Obtengo el cliente mas antiguo
                                        var oldClient = activeClients.dequeue()
                                        
                                        // Lo meto en clientes inactivos
                                        if oldClient != nil {
                                            inactiveClients.push(oldClient!)
                                            // El nuevo entra en el chat
                                            let fechaDeAhora = Date()

                                            var newClient = Client(nickname: nickname, addres: clientAddress!, timestamp: fechaDeAhora )
                                            withUnsafeBytes(of: ChatMessage.Welcome) { sendBuffer.append(contentsOf: $0) }
                                            withUnsafeBytes(of: true) { sendBuffer.append(contentsOf: $0) }
                                        
                                            try activeClients.enqueue(newClient)
                                            try self.serverSocket.write(from: sendBuffer, to: clientAddress!)
                                            sendBuffer.removeAll()
                                        }
                                                        
                                    }

                                    break;
                                case .Writer:
                                    count += nickname.count

                                    let text = buffer.advanced(by: count + 1).withUnsafeBytes {
                                        String(cString: $0.bindMemory(to: UInt8.self).baseAddress!)
                                    }
                                    buffer.removeAll()

                                    // Compruebo si esta en la lista
                                    
                                    var contains = activeClients.contains{ $0.nickname == nickname }

                                    if contains {
                                        // Lo elimino temporalmente
                                        activeClients.remove{ $0.nickname == nickname }

                                        // Lo vuelvo a meter
                                        let fechaDeAhora = Date()
                                        var newClient = Client(nickname: nickname, addres: clientAddress!, timestamp: fechaDeAhora )
                                        do {
                                            try activeClients.enqueue(newClient)
                                        } catch  {
                                            print("Error al volver a meterlo")
                                            
                                        }

                                        print("WRITER received from \(nickname): \(text)")

                                    func sendAll(client: Client) {
                                        // Envio el mensaje
                                        
                                        var sendBuffer = Data(capacity: 1000)
                                        withUnsafeBytes(of: ChatMessage.Server) { sendBuffer.append(contentsOf: $0) }
                                        
                                        nickname.utf8CString.withUnsafeBytes { sendBuffer.append(contentsOf: $0) }
                                        ": \(text)".utf8CString.withUnsafeBytes { sendBuffer.append(contentsOf: $0) }
                                                                        
                                        do {
                                            if client.addres != clientAddress! {
                                                try self.serverSocket.write(from: sendBuffer, to: client.addres)
                                            }
                                            
                                            sendBuffer.removeAll()
                                        } catch {
                                            print("Error")
                                            
                                        }
                                    }
                                    activeClients.forEach(sendAll)

                                    }

                                    
                                    break;

                                default:
                                    print("Cualquier cosa")
                                    break;
                                    
                                    
                            }
                        }
                    } while true
                } catch let error {
                    //print("Error leyendo mensaje")
                    print(error)                   
                    
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
                case "L":
                    print("ACTIVE CLIENTS")
                    print("==============")
                        
                    activeClients.forEach(printClients)
                    break;
                case "o" :
                    print("OLD CLIENTS")
                    print("==============")
                        
                    inactiveClients.forEach(printClients)
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