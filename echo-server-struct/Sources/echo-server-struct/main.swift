import Socket
import Foundation

let port = 7667

struct Point {
    var x: Double
    var y: Double
}

do {
    let serverSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
    try serverSocket.listen(on: port)
    print("Listening on \(port)")
    var buffer = Data(capacity: 1000)
    repeat {
        let (bytesRead, clientAddress) = try serverSocket.readDatagram(into: &buffer)
        if let address = clientAddress {
            let (clientHostname, clientPort) = Socket.hostnameAndPort(from: address)!
            print("Received length \(bytesRead) from \(clientHostname):\(clientPort)")

            let value = buffer.withUnsafeBytes {
                $0.load(as: Point.self)
            }
            print("Point: \(value)")
        }
        buffer.removeAll()
    } while true
} catch let error {
    print("Connection error: \(error)")
}
