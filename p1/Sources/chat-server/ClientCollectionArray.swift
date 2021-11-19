//
//  ClientCollectionArray.swift
//  Implementation of ClientCollection that uses an array as the backend.
//
import Socket

/// Implements a `ClientCollection` using an Array as the backend
struct ClientCollectionArray {
    struct Client {
        var address: Socket.Address
        var nick: String
    }
    
    private var clients = [Client]()
    let uniqueNicks: Bool

    init(uniqueNicks: Bool = true) {
        self.uniqueNicks = uniqueNicks
    }
}

/// ClientCollection functions have to be implemented here
extension ClientCollectionArray: ClientCollection { // Implementación para lectores y escritores
    
}

// Add additional extensions if you need to
