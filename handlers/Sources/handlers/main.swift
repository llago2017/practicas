import Foundation
import Socket

public class DatagramReader {
    enum DatagramReaderError : Error {
        case timeout
    }
    
    func readDatagram(from socket: Socket, into buffer: inout Data) throws {
        let (bytesRead, _) = try socket.readDatagram(into: &buffer)
        if bytesRead == 0 && errno == EAGAIN { 
            throw DatagramReaderError.timeout
        }
    }

    // Escaping para ayudar a gestionar la memoria, el bloque de código se va a utilizar después de usar la función
    public init(socket: Socket, capacity: Int, handler: @escaping (Data) -> Void) {
        var buffer = Data(capacity: capacity)
        
        let queue = DispatchQueue.global(qos: .userInteractive)
        queue.async {
            repeat {
                buffer.removeAll()
                do {
                    try self.readDatagram(from: socket, into: &buffer)
                    handler(buffer) // Una vez leo lo que llega lo envío, si esta tarda mucho, perderían datos y sería una mala solución
                } catch DatagramReaderError.timeout {
                    // Ignored
                } catch { //No gestión de errores
                    fatalError("Communications error: \(error)")    /// TODO: error handling
                }
            } while true
        }
    }
}

