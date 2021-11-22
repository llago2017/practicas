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

        if !uniqueNicks {
            clients.append(entrada)
        } else {
            for client in clients {
                if (client.nick == nick) {
                    throw ClientCollectionError.repeatedClient
                } 
                       
            } 
            clients.append(entrada)

        }
        //print(clients)
        
    }
    
    /**
     Remove the client(s) specified by the nick.
     Throws `ClientCollectionError.noSuchClient` if the client does not exist.
     */
    mutating func removeClient(nick: String) throws {
        var deleted = false;
        for client in clients {
            if client.nick == nick {
                print("Borrar")
                deleted = true;
            }            
        }

        if !deleted {
            throw ClientCollectionError.noSuchClient
        }
    }
    
    /**
     Search by address. Returns the nickname, or `nil` if the address was not found in the list.
     */
    func searchClient(address: Socket.Address) -> String? { 
        
        for client in clients {
            if client.address == address {
                return client.nick
            }
        }
        
        //DUDA
        //throw ClientCollectionError.noSuchClient
        return nil
    }
    
    /**
     Runs `body` closure for each element in the list.
     `rethrows` means that `forEach` will throw if the closure `throws`.
     */
    func forEach(_ body: (Socket.Address, String) throws -> Void) rethrows {

        // Ultimo usuario en la lista
        var last_client = clients.count - 1
        print(clients[last_client].nick)
        
        if clients.count > 0 {
             for client in clients {
                try! body(client.address, "test")
            }
        }
       
        
    }

}

// Add additional extensions if you need to
