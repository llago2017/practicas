import Socket
import Glibc
import Foundation

let server = "localhost"
let port: Int32 = 7667

struct Point {
    var x: Double
    var y: Double
}

do {
    guard let serverAddress = Socket.createAddress(for: server, on: port) else {
        print("Error creating Address")
        exit(1)
    }

    let clientSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)

    var buffer = Data(capacity: 1000)
    
    withUnsafeBytes(of: Point(x: 0.7, y: -1.25)) { buffer.append(contentsOf: $0) }
    withUnsafeBytes(of: 42) { buffer.append(contentsOf: $0) }
    try clientSocket.write(from: buffer, to: serverAddress)
} catch let error {
    print("Connection error: \(error)")
}
