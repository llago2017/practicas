protocol Queue {
    associatedtype Element
    
    mutating func enqueue(_ value: Element)
    mutating func dequeue() -> Element?
    
    var isEmpty: Bool { get }
    func peek() -> Element?
}

struct ArrayQueue<T> : Queue {
    private var storage = [T]()
    
    mutating func enqueue(_ value: T) {
        storage.append(value)
    }
    
    mutating func dequeue() -> T? {
        storage.removeFirst()
    }
    
    var isEmpty: Bool {
       isEmpty ? true:  storage.isEmpty
    }
    
    func peek() -> Element? {
        storage.first
    }
}

/*func testQueue() {
    var q = ArrayQueue<String>()
    if !q.isEmpty { print("isEmpty should be true when the queue is empty") }
    if q.dequeue() != nil { print("dequeue should return nil on an empty queue") }
    if q.peek() != nil { print("peek should return nil on an empty queue") }
    
    ["the", "rain", "in", "Spain"].forEach { q.enqueue($0) }
    
    var v = q.peek()
    if v != "the" { print("peek error, should return 'the' but your implementation returned \(v)") }
    v = q.peek()
    if v != "the" { print("peek error, should return 'the' but your implementation returned \(v)") }

    v = q.dequeue()
    if v != "the" { print("dequeue error, should return 'the' but your implementation returned \(v)") }

    q.dequeue()  // rain
    q.dequeue()  // in
    
    v = q.peek()  // Spain
    if v != "Spain" { print("peek error, should return 'Spain' but your implementation returned \(v)") }

    v = q.dequeue()
    if v != "Spain" { print("dequeue error, should return 'Spain' but your implementation returned \(v)") }

    if q.dequeue() != nil { print("dequeue error, should return nil") }
    if q.peek() != nil { print("peek error, should return nil") }
    if !q.isEmpty { print("isEmpty should be true when the queue is empty") }

    q.enqueue("test")
    if q.isEmpty { print("queue should not be empty") }
}

testQueue()
print("Fin de comprobaciones basicas")*/

extension ArrayQueue {
    mutating func reverse() {
        storage.reverse()
    }
}

func testReverse() {
    var q = ArrayQueue<String>()    
    ["the", "rain", "in", "Spain"].forEach { q.enqueue($0) }

    q.reverse()
    var reversed = ["Spain", "in", "rain", "the"]

    if q.peek() != reversed[0] {
        print("Funcion reverse no funciona correctamente")
        
    }
}

testReverse()
print("Fin prueba reverse")
