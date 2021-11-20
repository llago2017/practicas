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

            if isReader {
                print("El usuario es un lector") 
                 
            
            } else {
                print("El usuario es un escritor")
                let tests = ChatMessage.Init

                // Buffer para mensaje init
                var buffer = Data(capacity: 1000)
                withUnsafeBytes(of: tests) { buffer.append(contentsOf: $0) }
                nick.utf8CString.withUnsafeBytes { buffer.append(contentsOf: $0) }
                try clientSocket.write(from: buffer , to: serverAddress)

                print("Escriba su mensaje: ")   
                let message = readLine()!

                try clientSocket.write(from: message, to: serverAddress)
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
