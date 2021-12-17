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
         // Your code here
        print("Iniciando cliente")
        do {
            guard let serverAddress = Socket.createAddress(for: host, on: Int32(port)) else {
                print("Error creating Address")
                exit(1)
            }
            let clientSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)

            // Buffer para mensaje init
            let tests = ChatMessage.Init
            var sendbuffer = Data(capacity: 1000)
            var buffer = Data(capacity: 1000)
            withUnsafeBytes(of: tests) { sendbuffer.append(contentsOf: $0) }
            nick.utf8CString.withUnsafeBytes { sendbuffer.append(contentsOf: $0) }
            try clientSocket.write(from: sendbuffer , to: serverAddress)

            do {
                    try clientSocket.setReadTimeout(value: 10 * 1000)

                    let (bytesRead, _) = try clientSocket.readDatagram(into: &buffer)
                    
                    if bytesRead == 0 && errno == EAGAIN { 
                        print("Server unreachable")
                        exit(1)
                    
                    }
                    var readBuffer = buffer
                    
                    var value = ChatMessage.Init
                    var offset = MemoryLayout<ChatMessage>.size
                    var copyBytes = withUnsafeMutableBytes(of: &value) {
                        buffer.copyBytes(to: $0, from: 0..<offset)
                    }

                    //offset += 1 

                    print(value)
                    
                    if value == ChatMessage.Welcome {
                        print("Mensaje de bienvenida")
                        //readBuffer = readBuffer.advanced(by:count)

                        var accepted: Bool = true
                        let count = MemoryLayout<Bool>.size
                        var bytesCopied = withUnsafeMutableBytes(of: &accepted) {
                            buffer.copyBytes(to: $0, from: offset..<offset+count)
                        }

                        print("Estado: ")
                        print(accepted)
                        
                        
                        readBuffer.removeAll()
                    }
                    
                } catch {
                        // Ignored
                }


            

            
        } catch let error {
            print("Connection error: \(error)")
        }
        
        
    }
}


// Add additional functions using extensions
