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
    }
}

// Add additional functions using extensions
