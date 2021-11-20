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
    mutating func addClient(address: Socket.Address, nick: String) throws {
        // Creo el struct de cliente y lo añado al array con todos los clientes
        let entrada = Client(address: address, nick: nick)
        clients.append(entrada)
    }
    
    /**
     Remove the client(s) specified by the nick.
     Throws `ClientCollectionError.noSuchClient` if the client does not exist.
     */
    mutating func removeClient(nick: String) throws {

        for client in clients {
            if client.nick == nick {
                print("Borrar")
            }            
        }
    }
    
    /**
     Search by address. Returns the nickname, or `nil` if the address was not found in the list.
     */
    func searchClient(address: Socket.Address) -> String? { return "test"}
    
    /**
     Runs `body` closure for each element in the list.
     `rethrows` means that `forEach` will throw if the closure `throws`.
     */
    func forEach(_ body: (Socket.Address, String) throws -> Void) rethrows {}
}

// Add additional extensions if you need to
