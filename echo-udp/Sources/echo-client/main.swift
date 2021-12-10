import Socket
import Foundation
#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

let server = "127.0.0.1"
let port: Int32 = 7667

do {
    guard let serverAddress = Socket.createAddress(for: server, on: port) else {
        print("Error creating Address")
        exit(1)
    }

    let clientSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)

    var buffer = Data(capacity: 1000)
    var finished = false
    repeat {
        print("Enter message: ", terminator: "")
        if let message = readLine(), message != ".quit" {
            try clientSocket.write(from: message, to: serverAddress)
            let _ = try clientSocket.readDatagram(into: &buffer)
            let response = String(decoding: buffer, as: UTF8.self)
            print("Response: \(response)")
            buffer.removeAll()
        } else {
            finished = true
        }
    } while !finished
} catch let error {
    print("Connection error: \(error)")
}
