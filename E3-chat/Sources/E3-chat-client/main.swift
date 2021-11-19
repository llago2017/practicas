import Socket
import Glibc
import Foundation

print("Cliente")
print("Bienvenid@ al chat! Elija una de las siguientes opciones: ")
print("1. Enviar un String")
print("2. Enviar un Int")
print("3. Salir")

var message: String
var opcion = readLine();

do {
    guard let serverAddress = Socket.createAddress(for: "localhost", on: 7667) else {
        print("Error creating Address")
            exit(1)
    }

    var buffer = Data(capacity: 1000)
    let clientSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
    switch opcion {
    case "1":
        print("Inserte String: ")
        message = (readLine()!)
        //let clientSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
        //message.utf8CString.withUnsafeBytes
        try clientSocket.write(from: message, to: serverAddress)
        break;

    case "2":
        print("Inserte número entero")
        let number = readLine()!            
        
            // Envío
            try clientSocket.write(from: number, to: serverAddress)

            // Recibo
            let (bytesRead, serverAddress) = try clientSocket.readDatagram(into: &buffer)
            let str = buffer.withUnsafeBytes {
                        String(cString: $0.bindMemory(to: UInt8.self).baseAddress!)
                    }
                    
                print("Doble: \(str)")
        break;

    case "3":
        print("Adiós!")
        break;
        
    default:
        print("Opción no válida")
        
        
    }
    
} catch let error {
    print("Connection error: \(error)")
}