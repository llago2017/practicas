import Socket
import Foundation
import Dispatch
let port = 7667

do {
    let serverSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
    try serverSocket.listen(on: port)
    print("Listening on \(port)")
    var buffer = Data(capacity: 1000)
    func servidor() {
            do {
                let (bytesRead, clientAddress) = try serverSocket.readDatagram(into: &buffer)
                if let address = clientAddress {
                    let (clientHostname, clientPort) = Socket.hostnameAndPort(from: address)!
                    let message = String(decoding: buffer, as: UTF8.self)
                    print("Received length \(bytesRead) from \(clientHostname):\(clientPort)")
                    print("Message: \(message)")

                    // Send response
                    try serverSocket.write(from: message, to: address)
                                        
                }
                buffer.removeAll()
                
            } catch let error {
                print("Connection error: \(error)")
            }
            
    }

    func escribir(){
        if let message = readLine(), message != "q" {
            print("Enter 'q' (+ Enter) to quit.")
            
        } else {
            exit(1)
        }
    }

    let queue = DispatchQueue.global() // Envío trabajos que ejecuta en paralelo

        // Mando trabajos a la cola, que son bloques de código
        queue.async {
            servidor()
        }

        queue.async {
            escribir()
        }

    repeat {
        
  
    } while true
    

    /*repeat {
            if let message = readLine(), message != "q" {
            print("Enter 'q' (+ Enter) to quit.")
            
            } else {
                exit(1)
            }
    } while true*/

    

    
} catch let error {
    print("Connection error: \(error)")
}