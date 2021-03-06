print("Servidor")

import Socket
import Foundation

var port = 7667
var arguments = CommandLine.arguments
if !arguments.isEmpty {
    if arguments.count > 1 {
        port = Int(arguments[1])!
    }
    
}

// Creo el socket (canal de comunicaciones) abro el del servidor
// try por si falla, reservo un recurso de la máquiona para nosotros
// abre para una conexión TCP
//let serverSocket = try Socket.create()

// Usamos UDP --> No hay control de conexión o errores
// .inet --> Internet
// Socket UDP para ESCUCHAR (es la mitad del servidor)
 // Puerto conocido para escuchar
do {
    let serverSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
    try serverSocket.listen(on: port)
    // Mensajes que aparecen en consola
    print("Listening on \(port)")
    // Reservo espacio en memoria para leer los mensajes que llegan
    var buffer = Data(capacity: 1000) // El tipo Data es un array de tamaño fijo en el que metemos bytes
        // Leo lo que viene y lo guardo en el buffer con & se puede modificar la variable
        // Se queda esperando hasta que llegue un datagrama (o se puede definir un timeout)
        repeat {
            let (bytesRead, clientAddress) = try serverSocket.readDatagram(into: &buffer)
            // Cuando se conecta uno me dice la dirección y los bytes que envía
            if let address = clientAddress {
                let (clientHostname, clientPort) = Socket.hostnameAndPort(from: address)!

                
                print("Received length \(bytesRead) from \(clientHostname):\(clientPort)")

                let str = buffer.withUnsafeBytes {
                        String(cString: $0.bindMemory(to: UInt8.self).baseAddress!)
                    }
                    
                print("Recibido: \(str)")

                do {
                     if Int(str) != nil {
                         let result = Int(str)!*2
                         //withUnsafeBytes(of: Int(result)) { buffer.append(contentsOf: $0) }
                         try serverSocket.write(from: String(result), to: clientAddress!)
                         print(result)
                     }
                } catch {
                    print("Error")
                    
                }

               
                
                //try serverSocket.write(from: message, to: clientAddress!)
                // El mensaje siempre es un array de bytes y hay que decodificarlos para entenderlos
            }
            buffer.removeAll()
        } while true //Bucle infinito, siempre se queda esperando a un mensaje y lo imprime
        

} catch let error {
    print("Connection error: \(error)")
    
}