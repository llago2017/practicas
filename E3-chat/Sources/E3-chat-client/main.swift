import Socket
import Glibc

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

    switch opcion {
    case "1":
        print("Inserte String: ")
        message = readLine()!
        let clientSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
        try clientSocket.write(from: message, to: serverAddress)
        break;

    case "2":
        print("Inserte número entero")
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