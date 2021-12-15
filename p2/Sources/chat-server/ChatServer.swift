//
//  ChatServer.swift
//

import Foundation
import Socket
import ChatMessage
import Collections

// Your code here

struct Client() {
    var nickname: String
    var addres: Socket.Address
    var timestamp: Date
}

struct InactiveClient {
    var nickname: String
    var timestamp: Date
}

var activeCLientrs = ArrayQueue<Client>
var InactiveClient = ArrayStack<InactiveClient> 