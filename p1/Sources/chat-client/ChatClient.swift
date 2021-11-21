//
//  ChatClient.swift
//

import Foundation
import Socket
import ChatMessage

enum ChatClientError: Error {
    case wrongAddress
    case networkError(socketError: Error)
    case protocolError
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
    
    var isReader: Bool { return nick == "reader" }
    
    func run() throws {
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
            var buffer = Data(capacity: 1000)
            withUnsafeBytes(of: tests) { buffer.append(contentsOf: $0) }
            nick.utf8CString.withUnsafeBytes { buffer.append(contentsOf: $0) }
            try clientSocket.write(from: buffer , to: serverAddress)
            buffer.removeAll()

            if isReader {
                print("El usuario es un lector")
                // Recibo
                repeat {
                    let (bytesRead, serverAddress) = try clientSocket.readDatagram(into: &buffer)
                let str = buffer.withUnsafeBytes {
                        String(cString: $0.bindMemory(to: UInt8.self).baseAddress!)
                }
                    
                print("Doble: \(str)")
                    
                } while true
                
                 
            
            } else {
                print("El usuario es un escritor")

                print("Escriba su mensaje: ")   
                let message = readLine()!

                // Envio el mensaje
                withUnsafeBytes(of: ChatMessage.Writer) { buffer.append(contentsOf: $0) }
                message.utf8CString.withUnsafeBytes { buffer.append(contentsOf: $0) }
                try clientSocket.write(from: buffer, to: serverAddress)
            if message == ".quit" {
                print("Hasta pronto")
                exit(1)
                
            }
            
        }

            
        } catch let error {
            print("Connection error: \(error)")
        }
        
        
    }
}

// Add additional functions using extensions
