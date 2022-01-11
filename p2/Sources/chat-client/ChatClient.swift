//
//  ChatClient.swift
//

import Foundation
import Socket
import ChatMessage
import Dispatch
import Glibc

enum ChatClientError: Error {
    case wrongAddress
    case networkError(socketError: Error)
    case protocolError
    case timeout        // Thrown when the server does not respond to Init after 10s
}

class ChatClient {
    let host: String
    let port: Int
    let nick: String
    
    init(host: String, port: Int, nick: String) {
        self.host = host
        self.port = port
        self.nick = nick
    }
        
    func run() throws {
        // Your code here
        var accepted: Bool? = nil

        do {
            guard let serverAddress = Socket.createAddress(for: host, on: Int32(port)) else {
                print("Error creating Address")
                exit(1)
            }

            let clientSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
            // Si no tengo información de haber sido aceptado mando el init y espero al mensaje de welcome
            if accepted == nil { 

                // Buffer para mensaje init
                let tests = ChatMessage.Init
                var sendbuffer = Data(capacity: 1000)
                var buffer = Data(capacity: 1000)
                withUnsafeBytes(of: tests) { sendbuffer.append(contentsOf: $0) }
                nick.utf8CString.withUnsafeBytes { sendbuffer.append(contentsOf: $0) }
                try clientSocket.write(from: sendbuffer , to: serverAddress)
                sendbuffer.removeAll()
                // Preparo timeout para recibir welcome
                try clientSocket.setReadTimeout(value: 10 * 1000)
                let (bytesRead, _) = try clientSocket.readDatagram(into: &buffer)
                if bytesRead == 0 && errno == EAGAIN { 
                    print("Server Unreachable")
                    exit(1)
                    
                }

                var readBuffer = buffer
                var value = ChatMessage.Init
                var offset = MemoryLayout<ChatMessage>.size
                var copyBytes = withUnsafeMutableBytes(of: &value) {
                    buffer.copyBytes(to: $0, from: 0..<offset)
                }

                if value == ChatMessage.Welcome {
                            
                    let count = MemoryLayout<Bool>.size
                    var bytesCopied = withUnsafeMutableBytes(of: &accepted) {
                        readBuffer.copyBytes(to: $0, from: offset..<offset+count)
                    }

                    if accepted != nil && accepted! {
                        print("Mini-Chat v2.0: Welcome \(self.nick)")

                    }

                    if accepted != nil && !accepted! {
                        print("Mini-Chat v2.0: IGNORED new user \(self.nick), nick already used")
                        exit(1)
                                
                    }                      
                            
                    readBuffer.removeAll()
                }

            }
                                                    

            func handler(buffer: Data, bytesRead: Int, addres: Socket.Address?) {
                // Bloque que extrae los datos del buffer y realiza la acción deseada
                        
                var readBuffer = buffer

                var value = ChatMessage.Init

                var offset = MemoryLayout<ChatMessage>.size

                var copyBytes = withUnsafeMutableBytes(of: &value) {

                    buffer.copyBytes(to: $0, from: 0..<offset)

                }

                    
                if value == ChatMessage.Server {
                    var nickname = readBuffer.advanced(by: offset).withUnsafeBytes {
                        String(cString: $0.bindMemory(to: UInt8.self).baseAddress!)
                    }    

                    offset += nickname.count

                    let text = readBuffer.advanced(by: offset + 1).withUnsafeBytes {
                        String(cString: $0.bindMemory(to: UInt8.self).baseAddress!)
                    }                
                    
                    print("\n\(nickname): \(text)")
                    print(">>", terminator: "")
                    fflush(stdout)

                    readBuffer.removeAll()                  
                }
                
            }
            
            if accepted! {
                let _ = try DatagramReader(socket: clientSocket, capacity: 1000, handler: handler) 
        

                repeat {
                    print(">>", terminator: "")             
                    let queue = DispatchQueue.global() 
                    if let message = readLine(), message != ".quit" {
                        queue.async {
                            do {
                                // Buffer para mensaje init
                                let writer = ChatMessage.Writer
                                var sendbuffer = Data(capacity: 1000)
                                withUnsafeBytes(of: writer) { sendbuffer.append(contentsOf: $0) }
                                self.nick.utf8CString.withUnsafeBytes { sendbuffer.append(contentsOf: $0) }
                                message.utf8CString.withUnsafeBytes { sendbuffer.append(contentsOf: $0) }
                                try clientSocket.write(from: sendbuffer , to: serverAddress)
                                    sendbuffer.removeAll()
                            } catch  {
                                print("Error mandando mensaje")              
                            }
                        }
                            
                    } else {
                        // Mando mensaje de Logout
                        queue.async {
                            do {
                                // Buffer para mensaje init
                                let Logout = ChatMessage.Logout
                                var sendbuffer = Data(capacity: 1000)
                                withUnsafeBytes(of: Logout) { sendbuffer.append(contentsOf: $0) }
                                self.nick.utf8CString.withUnsafeBytes { sendbuffer.append(contentsOf: $0) }
                                try clientSocket.write(from: sendbuffer , to: serverAddress)
                                sendbuffer.removeAll()
                            } catch let error  {
                                print("Connection error: \(error)")
                            
                            }
                            exit(1)
                        }
                    }
                } while true
            }                      


        } catch let error {
            print("Connection error: \(error)")
        }
        
        
    }
}


// Add additional functions using extensions
