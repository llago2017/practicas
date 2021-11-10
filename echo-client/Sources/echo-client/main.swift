import Socket
import Glibc

let server = "localhost"
let port: Int32 = 7667
let message = "Hello, world!"

do {
    guard let serverAddress = Socket.createAddress(for: server, on: port) else {
        print("Error creating Address")
        exit(1)
    }

    let clientSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
    try clientSocket.write(from: message, to: serverAddress)
} catch let error {
    print("Connection error: \(error)")
}
