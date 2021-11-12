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

            var offset = 0
            /*let number = buffer.withUnsafeBytes {
                $0.load(fromByteOffset: offset, as: Int.self)
            }
            offset += MemoryLayout<Int>.size
            print("Number: \(number)")
            print("Current offset: \(offset)")*/

            let point = buffer.withUnsafeBytes {
                $0.load(fromByteOffset: offset, as: Point.self)
            }
            print("Point: \(point)")
            offset += MemoryLayout<Point>.size
            print("Current offset: \(offset)")

            let number = buffer.withUnsafeBytes {
                $0.load(fromByteOffset: offset, as: Int.self)
            }
            
            print("Number: \(number)")
        }
        buffer.removeAll()
    } while true
} catch let error {
    print("Connection error: \(error)")
}
