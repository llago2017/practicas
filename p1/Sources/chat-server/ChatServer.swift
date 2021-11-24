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
            repeat {
                let (_, clientAddress) = try serverSocket.readDatagram(into: &buffer)
                // Cuando se conecta uno me dice la dirección y los bytes que envía
                if clientAddress != nil {

                
                    //print("Received length \(bytesRead) from \(clientHostname):\(clientPort)")
                   var readBuffer = buffer
                    

                    var value = ChatMessage.Init
                    let count = MemoryLayout<ChatMessage>.size
                    var _ = withUnsafeMutableBytes(of: &value) {
                        readBuffer.copyBytes(to: $0, from: 0..<count)
                    }
                    

                    readBuffer = readBuffer.advanced(by:count)

                    let msg = buffer.advanced(by: count).withUnsafeBytes {
                            String(cString: $0.bindMemory(to: UInt8.self).baseAddress!)
                    }

                    switch value {
                    case .Init:
                        var isReader: Bool { return msg == "reader" }
                        
                        if isReader {
                            print("INIT received from \(msg)")
                            try readers.addClient(address: clientAddress!, nick: msg)
                            
                        } else {

                            do {
                                try writers.addClient(address: clientAddress!, nick: msg)
                                print("INIT received from \(msg)")

                                func sendAll(address: Socket.Address, nick: String) {
                                    // Envio el mensaje
                                    
                                    var sendBuffer = Data(capacity: 1000)
                                    withUnsafeBytes(of: ChatMessage.Server) { sendBuffer.append(contentsOf: $0) }
                                    // DUDA FORMATO CORRECTO
                                    "server".utf8CString.withUnsafeBytes { sendBuffer.append(contentsOf: $0) }
                                    ": \(msg) joins the chat".utf8CString.withUnsafeBytes { sendBuffer.append(contentsOf: $0) }
                                    //print(toReader)
                                    
                                    do {
                                        try serverSocket.write(from: sendBuffer, to: address)
                                        sendBuffer.removeAll()
                                    } catch {
                                        print("Error")
                                        
                                    }
                                }
                                readers.forEach(sendAll)
                            } catch {
                                print("INIT received from \(msg). IGNORED, nick already used")
                            }
                              
                        }
                            

                        break;
                    
                    case .Writer:
                         let Wnick = writers.searchClient(address:clientAddress!)
                         if Wnick != nil {
                            print("WRITER received from \(Wnick!): \(msg)")

                            func sendAll(address: Socket.Address, nick: String) {
                                // Envio el mensaje
                                
                                var sendBuffer = Data(capacity: 1000)
                                withUnsafeBytes(of: ChatMessage.Server) { sendBuffer.append(contentsOf: $0) }
                                // DUDA FORMATO CORRECTO
                                Wnick!.utf8CString.withUnsafeBytes { sendBuffer.append(contentsOf: $0) }
                                ": \(msg)".utf8CString.withUnsafeBytes { sendBuffer.append(contentsOf: $0) }
                                                                
                                do {
                                    try serverSocket.write(from: sendBuffer, to: address)
                                    sendBuffer.removeAll()
                                } catch {
                                    print("Error")
                                    
                                }
                            }
                           readers.forEach(sendAll)
                           
                         } else {
                             print("WRITER received from unknown client. IGNORED")
                             
                         }
                         break;
                         
                        
                        
                    default:
                        print("En proceso")
                        
                        
                    }
                }
            
            buffer.removeAll()
            } while true
        } catch let error {
            throw ChatServerError.networkError(socketError: error)
        }
    }
}

// Add additional functions using extensions
