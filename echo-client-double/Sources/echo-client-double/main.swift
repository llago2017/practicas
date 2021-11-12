import Socket
import Glibc
import Foundation

let server = "localhost"
let port: Int32 = 7667
let number = 42

do {
    guard let serverAddress = Socket.createAddress(for: server, on: port) else {
        print("Error creating Address")
        exit(1)
    }

    let clientSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
    var buffer = Data(capacity: 1000)
    withUnsafeBytes(of: Double(number)) { buffer.append(contentsOf: $0) }


    try clientSocket.write(from: buffer, to: serverAddress)
} catch let error {
    print("Connection error: \(error)")
}
